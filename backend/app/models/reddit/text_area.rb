class Reddit::TextArea < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  def self.import(widget, data)
    return if data.nil?

    text_area = Reddit::TextArea.find_by_widget_id(widget.id)
    text_area = Reddit::TextArea.new if text_area.nil?

    text_area.widget = widget
    text_area.text = data["text"]
    text_area.text_html = data["text_html"]

    text_area.save! if text_area.changed?

    return text_area
  end
end