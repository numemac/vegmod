class InspectController < ApplicationController
  
  def index
    options = { depth: 1 }
    id = params[:id]
    association = params[:association]
    current_page = params[:page] || 1
    per_page = params[:per_page] || 10
    search = params[:search] || ""
    measure = params[:measure] || nil
    unit = params[:unit] || nil
    interval = params[:interval] || nil
    changed = params[:changed] || nil
  
    offset = (current_page.to_i - 1) * per_page.to_i

    unless id&.present?
      all_entries = search.present? ? model_class.full_text_search(search) : model_class.all
      total_entries = all_entries.count
      total_pages = (total_entries.to_f / per_page.to_f).ceil
      if current_page.to_i > total_pages
        current_page = [total_pages, 1].max
        offset = (current_page.to_i - 1) * per_page.to_i
      end
      paginated_entries = all_entries.order(id: :desc).offset(offset).limit(per_page)
      pagination = {
        current_page: current_page,
        total_pages: total_pages,
        total_entries: total_entries,
        per_page: per_page,
        search: search
      }

      render json: {
        type: "InspectIndex",
        apiEndpoint: request.original_url,
        entries: model_class.blueprinter_class.render_as_hash(paginated_entries, options),
        model: model_class.model,
        pagination: pagination,
        models: model_mappings(web_indexable: true).keys
      }
      return
    end

    if params[:association]
      association = model_class.has_many_associations.find { 
        |a| a[:name].to_sym == params[:association].to_sym 
      }
      options[:association] = association[:name] if association
    end

    record_query = model_class.where(id: id).includes(association ? association[:name] : nil)
    record = record_query.first

    all_entries = association ? (
      search.present? ? (
        association[:klass].where(
          id: record.send(association[:name])
        ).full_text_search(search)
      ) : record.send(association[:name])
    ) : model_class.where(id: id).order(id: :desc)
    options[:association_entries] = all_entries

    total_entries = all_entries.count
    total_pages = (total_entries.to_f / per_page.to_f).ceil
    if current_page.to_i > total_pages
      current_page = [total_pages, 1].max
      offset = (current_page.to_i - 1) * per_page.to_i
    end
    pagination = {
      current_page: current_page,
      total_pages: total_pages,
      total_entries: total_entries,
      per_page: per_page,
      search: search
    }

    options[:offset] = offset
    options[:limit] = per_page

    if measure.present? && unit.present? && interval.present?
      Rails.logger.info "using custom metric"
      options[:metric] = record.metrics.where(measure: measure, unit: unit, interval: interval)&.first
      if options[:metric].nil?
        if changed.present?
          if changed == "measure"
            options[:metric] = record.metrics.where(measure: measure)&.first
          elsif changed == "unit"
            options[:metric] = record.metrics.where(unit: unit)&.first
          elsif changed == "interval"
            options[:metric] = record.metrics.where(interval: interval)&.first
          end
        end
      end
    end

    if options[:metric].nil?
      Rails.logger.info "using default metric"
      options[:metric] = record.default_metric || nil
    end
  
    render json: {
      type: "InspectShow",
      apiEndpoint: request.original_url,
      association: association ? association[:name] : nil,
      data: record.as_json(options),
      id: id,
      model: model_class.model,
      pagination: pagination,
      models: model_mappings(web_indexable: true).keys
    }
  end

  private

  def model_mappings(web_indexable: false)
    [ Reddit::Comment, Reddit::FlairTemplate, Reddit::Redditor, Reddit::RemovalReason, Reddit::Report, Reddit::Submission, Reddit::SubredditRedditor, Reddit::Subreddit, Reddit::Rule, Reddit::VisionLabel, Reddit::PrawLog, Reddit::SidebarVote, Reddit::XComment, Reddit::XSubmission, Reddit::Widget, Reddit::ButtonWidget, Reddit::ImageWidget, Reddit::CommunityList, Reddit::Image, Reddit::WidgetStyle ].select {
      |m|
      web_indexable ? m.respond_to?(:web_indexable?) && m.web_indexable? : true  
    }.inject({}) {
      |h, m|
      model_name = m.name.split("::").last.underscore.downcase.pluralize
      h["reddit/#{model_name}"] = m
      h
    }
  end

  def model_class
    if model_mappings.has_key?(params[:model])
      return model_mappings[params[:model]]
    else
      raise "Unknown model #{params[:model]}, models: #{model_mappings.keys}"
    end
  end

end