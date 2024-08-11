class InspectController < ApplicationController
  
  def index
    options = { depth: 1 }
    id = params[:id]
    association = params[:association]
    current_page = params[:page] || 1
    per_page = params[:per_page] || 10
    offset = (current_page.to_i - 1) * per_page.to_i

    unless id&.present?
      all_entries = model_class.all
      total_entries = all_entries.count
      total_pages = (total_entries.to_f / per_page.to_f).ceil
      paginated_entries = all_entries.order(updated_at: :desc).offset(offset).limit(per_page)
      pagination = {
        current_page: current_page,
        total_pages: total_pages,
        total_entries: total_entries,
        per_page: per_page,
      }

      render json: {
        type: "InspectIndex",
        apiEndpoint: request.original_url,
        entries: model_class.blueprinter_class.render_as_hash(paginated_entries, options),
        model: model_class.model,
        pagination: pagination
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

    all_entries = association ? record.send(association[:name]) : model_class.where(id: id)
    total_entries = all_entries.count
    total_pages = (total_entries.to_f / per_page.to_f).ceil
    paginated_entries = all_entries.offset(offset).limit(per_page)
    pagination = {
      current_page: current_page,
      total_pages: total_pages,
      total_entries: total_entries,
      per_page: per_page,
    }
  
    render json: {
      type: "InspectShow",
      apiEndpoint: request.original_url,
      association: association ? association[:name] : nil,
      data: record.as_json(options),
      id: id,
      model: model_class.model,
      pagination: pagination,
    }
  end

  private

  def model_class
    mapping = {
      "reddit/comments" => Reddit::Comment,
      "reddit/flair_templates" => Reddit::FlairTemplate,
      "reddit/redditors" => Reddit::Redditor,
      "reddit/removal_reasons" => Reddit::RemovalReason,
      "reddit/reports" => Reddit::Report,
      "reddit/submissions" => Reddit::Submission,
      "reddit/subreddit_redditors" => Reddit::SubredditRedditor,
      "reddit/subreddits" => Reddit::Subreddit,
      "reddit/vision_labels" => Reddit::VisionLabel,
      "reddit/praw_logs" => Reddit::PrawLog,
    }

    if mapping.has_key?(params[:model])
      return mapping[params[:model]]
    else
      raise "Unknown model #{params[:model]}"
    end
  end

end