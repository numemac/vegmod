class Reddit::Image < RedditRecord
  include Externalable

  belongs_to :image_widget, class_name: Reddit::ImageWidget.name
  has_one :widget, through: :image_widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :image_widget, class_name: Reddit::Subreddit.name

  def label
    # get the host of the url
    uri = URI.parse(self.url)
    return uri.host
  end

  # helps with a long-standing reddit glitch where the image
  # never processes. the best thing to do is re-upload.
  def processing?
    url == "https://www.redditstatic.com/image-processing.png"
  end

  def submission
    uri = URI.parse(self.link_url)
    Reddit::Submission.find_by_permalink(uri.path)
  end

  def submission_id
    return self.submission.id
  end

  def external_url
    return self.url
  end

  def self.import(image_widget, data, order)
    return if data["url"].nil?

    image = Reddit::Image.where(image_widget: image_widget, order: order).first
    image = Reddit::Image.new if image.nil?

    image.image_widget = image_widget
    image.order = order
    image.height = data["height"]
    image.link_url = data["link_url"]
    image.url = data["url"]
    image.width = data["width"]

    if image.changed?
      # will ensure the image is processed
      image.save!
    else
      # still ensure the image is processed
      ProcessingImagePlugin.ensure_processed(image)
    end

    return image
  end
end