class KarmaRequirementPlugin < OldPlugin
  Reddit::Comment.plugin    self, :after_create, :evaluate_contribution
  Reddit::Submission.plugin self, :after_create, :evaluate_contribution

  def self.subreddits
    ['vegancirclejerkchat']
  end

  def self.score_required
    10
  end

  def self.violation?(redditor)
    return false if redditor.nil?
    return false if redditor.bot?

    # Actually uses the score from all subreddits
    # but still guide people to VCJ to build it
    return redditor.x.non_adversarial_score < score_required
  end

  def self.remove_contribution(contribution, subreddit, redditor)
    removal_reason = subreddit.search_removal_reason("karma")
    return unless removal_reason.present?
  
    contribution.praw.remove("Insufficient karma.", false, removal_reason.external_id)
    contribution.praw.send_removal_message(
      [
        "Your submission has been removed because you do not meet the karma requirements for this subreddit.",
        "Please participate in other vegan subreddits to build up your karma and try again later."
      ].join("\n\n")
    )
  end

  def self.evaluate_contribution(contribution)
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