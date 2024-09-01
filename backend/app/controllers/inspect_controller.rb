class InspectController < ApplicationController
  
  def index
    options = { depth: 1 }
    id = params[:id]
    association = params[:association]
    current_page = params[:page] || 1
    per_page = params[:per_page] || 10
    measure = params[:measure] || nil
    unit = params[:unit] || nil
    interval = params[:interval] || nil
  
    offset = (current_page.to_i - 1) * per_page.to_i

    unless id&.present?
      all_entries = model_class.all
      total_entries = all_entries.count
      total_pages = (total_entries.to_f / per_page.to_f).ceil
      paginated_entries = all_entries.order(id: :desc).offset(offset).limit(per_page)
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
        pagination: pagination,
        models: model_mappings.keys
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

    all_entries = association ? record.send(association[:name]) : model_class.where(id: id).order(id: :desc)
    total_entries = all_entries.count
    total_pages = (total_entries.to_f / per_page.to_f).ceil
    pagination = {
      current_page: current_page,
      total_pages: total_pages,
      total_entries: total_entries,
      per_page: per_page,
    }

    options[:offset] = offset
    options[:limit] = per_page

    if measure && unit && interval
      options[:metric] = record.metrics.where(measure: measure, unit: unit, interval: interval).first
    else
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
      models: model_mappings.keys
    }
  end

  private

  def model_mappings
    {
      "reddit/comments" =>              Reddit::Comment,
      "reddit/flair_templates" =>       Reddit::FlairTemplate,
      "reddit/redditors" =>             Reddit::Redditor,
      "reddit/removal_reasons" =>       Reddit::RemovalReason,
      "reddit/reports" =>               Reddit::Report,
      "reddit/submissions" =>           Reddit::Submission,
      "reddit/subreddit_redditors" =>   Reddit::SubredditRedditor,
      "reddit/subreddits" =>            Reddit::Subreddit,
      "reddit/rules" =>                 Reddit::Rule,
      "reddit/vision_labels" =>         Reddit::VisionLabel,
      "reddit/praw_logs" =>             Reddit::PrawLog,
      "reddit/sidebar_votes" =>         Reddit::SidebarVote,
      "reddit/x_comments" =>            Reddit::XComment,
      "reddit/x_submissions" =>         Reddit::XSubmission,
      "reddit/widgets" =>               Reddit::Widget,
      "reddit/button_widgets" =>        Reddit::ButtonWidget,
      "reddit/image_widgets" =>         Reddit::ImageWidget,
      "reddit/community_lists" =>       Reddit::CommunityList,
      "reddit/images" =>                Reddit::Image,
      "reddit/widget_styles" =>         Reddit::WidgetStyle,
      
    }
  end

  def model_class
    if model_mappings.has_key?(params[:model])
      return model_mappings[params[:model]]
    else
      raise "Unknown model #{params[:model]}"
    end
  end

end