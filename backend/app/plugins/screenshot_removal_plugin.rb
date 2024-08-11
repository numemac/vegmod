class ScreenshotRemovalPlugin < Plugin
  Reddit::VisionLabel.plugin self, :after_commit, :remove_screenshot

  def self.subreddits
    # downcase
    ['vegancirclejerk']
  end

  def self.social_media?(description)
    # downcase
    trigger_terms = [
      "social media"
    ]

    trigger_terms.any? { |term| description.include?(term) }
  end

  def self.text_message?(description)
    # downcase
    trigger_terms = [
      "text message",
      "text conversation",
      "text chat"
    ]

    trigger_terms.any? { |term| description.include?(term) }
  end

  def self.remove_screenshot(vision_label)
    return unless vision_label.present?
    return unless vision_label.label == "description"
    return unless vision_label.context_type == Reddit::Submission.name

    submission = vision_label.context
    subreddit = submission.subreddit
    return unless subreddit.display_name.downcase.in?(subreddits)

    return unless social_media?(vision_label.value) || text_message?(vision_label.value)

    removal_reason = subreddit.search_removal_reason("screenshot")
    if removal_reason.nil?
      Rails.logger.error "Removal reason 'screenshot' not found as substring for subreddit #{subreddit.label} reasons"
      return
    end

    submission.praw.remove(
      "Screenshot removal / '#{vision_label.app_url}'.",
      false,
      removal_reason.external_id
    )
  rescue => e
    Rails.logger.error "Error removing screenshot from submission #{submission.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end
end

    