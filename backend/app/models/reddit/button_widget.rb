class Reddit::ButtonWidget < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  def self.import(widget, data)
    return if data.nil?

    button_widget = Reddit::ButtonWidget.find_by_widget_id(widget.id)
    button_widget = Reddit::ButtonWidget.new if button_widget.nil?

    button_widget.widget = widget

    button_widget.save! if button_widget.changed?

    return button_widget
  end
end