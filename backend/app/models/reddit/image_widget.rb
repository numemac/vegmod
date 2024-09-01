class Reddit::ImageWidget < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  has_many :images, class_name: Reddit::Image.name, dependent: :destroy

  def processing?
    images.any?(&:processing?)
  end

  def self.import(widget, data)
    return if data.nil?

    image_widget = Reddit::ImageWidget.find_by_widget_id(widget.id)
    image_widget = Reddit::ImageWidget.new if image_widget.nil?

    image_widget.widget = widget

    image_widget.save! if image_widget.changed?

    if data.key?("data")
      existing_image_ids = image_widget.images.pluck(:id)
      import_image_ids = []

      data["data"].each_with_index do |data, order|
        image = Reddit::Image.import(image_widget, data, order)
        import_image_ids << image.id if image
      end

      # Delete images that were not imported, must be resolved
      Reddit::Image.where(
        image_widget: image_widget,
        id: (
          existing_image_ids - import_image_ids
        )
      ).destroy_all
    end

    return image_widget
  end
end