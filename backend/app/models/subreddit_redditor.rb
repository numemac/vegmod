class SubredditRedditor < ApplicationRecord
  belongs_to :subreddit
  belongs_to :redditor, optional: true

  has_many :submissions, dependent: :destroy
  has_many :comments, dependent: :destroy

  def label
    redditor_label = redditor&.label || "[deleted]"
    "#{redditor_label} on #{subreddit.label}"
  end

  def refresh_score!
    update!(score: submissions.sum(:score) + comments.sum(:score))
  end
end