class KarmaRequirementPlugin < Plugin
  Reddit::Comment.plugin    self, :after_create, :evaluate_contribution
  Reddit::Submission.plugin self, :after_create, :evaluate_contribution

  def self.subreddits
    ['vegancirclejerkchat']
  end

  def self.score_required
    10
  end

  def self.removal_reason(subreddit)
    subreddit.search_removal_reason("karma")
  end

  def self.violation?(redditor)
    return false if redditor.nil?
    return false if redditor.bot?

    # Actually uses the score from all subreddits
    # but still guide people to VCJ to build it
    return redditor.score < score_required
  end

  def self.removal_message(removal_reason, redditor)
    message = removal_reason.message
    score_report = redditor&.score_report
    message += "\n\n#{score_report}" if score_report.present?
    message
  end

  def self.remove_contribution(contribution, subreddit, redditor)
    removal_reason = removal_reason(subreddit)
    return unless removal_reason.present?
  
    contribution.praw.remove("Insufficient karma.", false, removal_reason.external_id)
    contribution.praw.send_removal_message(
      removal_message(removal_reason, redditor)
    )
  end

  def self.evaluate_contribution(contribution)
    disabled = true # waiting for more karma to be tracked
    return if disabled

    return unless contribution.present?

    subreddit = contribution.subreddit
    return unless subreddit.display_name.downcase.in?(subreddits)

    return if contribution&.submission&.x&.bot_disabled

    redditor = contribution.redditor
    return unless violation?(redditor)

    remove_contribution(contribution, subreddit, redditor)
  rescue => e
    Rails.logger.error "Error evaluating contribution #{contribution.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end
end