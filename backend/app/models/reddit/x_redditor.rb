class Reddit::XRedditor < RedditRecord
  belongs_to :redditor, class_name: Reddit::Redditor.name

  def refresh_score!
    adversarial_subreddits = Reddit::Subreddit.adversarial
    non_adversarial_subreddits = Reddit::Subreddit.non_adversarial

    update!(
      score: redditor.subreddit_redditors.sum(:score),
      adversarial_score: redditor.subreddit_redditors.where(subreddit: adversarial_subreddits).sum(:score),
      non_adversarial_score: redditor.subreddit_redditors.where(subreddit: non_adversarial_subreddits).sum(:score)
    )
  end
end