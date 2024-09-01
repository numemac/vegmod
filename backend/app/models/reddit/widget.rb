class Reddit::Widget < RedditRecord
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  has_one :widget_style, class_name: Reddit::WidgetStyle.name, dependent: :destroy
  has_one :image_widget, class_name: Reddit::ImageWidget.name, dependent: :destroy
  has_one :button_widget, class_name: Reddit::ButtonWidget.name, dependent: :destroy
  has_one :community_list, class_name: Reddit::CommunityList.name, dependent: :destroy

  def label
    return self.short_name
  end

  def detail_label
    return self.kind
  end

  def self.import(subreddit, data, order)
    return if data["id"].nil?

    widget = Reddit::Widget.find_by_external_id(data["id"])
    widget = Reddit::Widget.new if widget.nil?

    widget.subreddit = subreddit
    widget.order = order
    widget.external_id = data["id"]
    widget.kind = data["kind"]
    widget.short_name = data["short_name"]

    widget.save! if widget.changed?

    if data.key?("styles")
      Reddit::WidgetStyle.import(widget, data["styles"])
    end

    if widget.kind == "image"
      Reddit::ImageWidget.import(widget, data)
    elsif widget.kind == "button"
      Reddit::ButtonWidget.import(widget, data)
    elsif widget.kind == "community-list"
      Reddit::CommunityList.import(widget, data)
    end

    return widget
  end
end