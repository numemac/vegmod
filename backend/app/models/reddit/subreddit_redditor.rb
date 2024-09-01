class Reddit::SubredditRedditor < RedditRecord
  include Imageable

  belongs_to :subreddit, class_name: Reddit::Subreddit.name
  belongs_to :redditor, class_name: Reddit::Redditor.name, optional: true

  has_many :submissions, class_name: Reddit::Submission.name, dependent: :destroy
  has_many :comments, class_name: Reddit::Comment.name, dependent: :destroy
  has_many :sidebar_votes, class_name: Reddit::SidebarVote.name, dependent: :destroy

  def label
    redditor_label = redditor&.label || "[deleted]"
    "#{redditor_label} on #{subreddit.label}"
  end

  def detail_label
    "#{formatted_score} subreddit karma"
  end

  def formatted_score
    score.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
  end

  def image
    redditor&.image
  end

  def image_url
    redditor&.image_url
  end

  def refresh_score!
    update!(score: submissions.sum(:score) + comments.sum(:score))
  end
end