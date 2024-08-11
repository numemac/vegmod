class RedditInfoRemovalPlugin < Plugin
  Reddit::VisionLabel.plugin self, :after_commit, :remove_reddit_info

  def self.subreddits
    # downcase
    ['animalhaters']
  end

  # e.g. "and then somebody posted on r/vegan and said 'I'm vegan'"
  def self.contains_subreddit?(text)
    # regex to ensure r/ is at the beginning of the word and not in the middle of a word,
    # and that the subreddit name is at least 3 characters long
    text.match?(/\br\/\w{3,}\b/)
  end

  # e.g. "so, u/username said 'I'm vegan'"
  def self.contains_user?(text)
    text.match?(/\bu\/\w{3,}\b/)
  end

  def self.remove_reddit_info(vision_label)
    return unless vision_label.present?
    return unless vision_label.label == "rtesseract"
    return unless vision_label.context_type == Reddit::Submission.name

    submission = vision_label.context
    subreddit = submission.subreddit
    return unless subreddit.display_name.downcase.in?(subreddits)

    return unless contains_subreddit?(vision_label.value) || contains_user?(vision_label.value)

    # Omit personal & subreddit information. 
    removal_reason = subreddit.search_removal_reason("personal")
    if removal_reason.nil?
      Rails.logger.error "Removal reason 'personal' not found as substring for subreddit #{subreddit.label} reasons"
      return
    end

    submission.praw.remove(
      "Reddit info removal / '#{vision_label.app_url}'.",
      false,
      removal_reason.external_id
    )
  rescue => e
    Rails.logger.error "Error removing reddit info from submission #{submission.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end
end

    