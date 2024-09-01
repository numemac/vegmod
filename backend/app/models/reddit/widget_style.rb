class Reddit::WidgetStyle < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  def self.import(widget, data)
    return if data.nil?

    widget_style = Reddit::WidgetStyle.find_by_widget_id(widget.id)
    widget_style = Reddit::WidgetStyle.new if widget_style.nil?

    widget_style.widget = widget
    widget_style.background_color = data["background_color"]
    widget_style.header_color = data["header_color"]

    widget_style.save! if widget_style.changed?

    return widget_style
  end
end