class ProcessingImagePlugin < OldPlugin
  Reddit::Image.plugin self, :after_commit, :ensure_processed

  def self.ensure_processed(image)
    return unless image.present?
    return unless image.processing?

    submission = image.submission
    return unless submission.present?

    image_widget = image.image_widget
    subreddit = image_widget.subreddit
    return unless subreddit.present?

    subreddit.praw.widgets_mod_reupload_image(
      image_widget.widget.external_id,
      submission.url,
      image.link_url
    )
  rescue => e
    Rails.logger.error "Error running ProcessingImagePlugin for image #{image.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end

end