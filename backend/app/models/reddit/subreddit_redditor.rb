class Reddit::SubredditRedditor < RedditRecord
  include Imageable

  belongs_to :subreddit, class_name: Reddit::Subreddit.name
  belongs_to :redditor, class_name: Reddit::Redditor.name, optional: true

  has_many :submissions, class_name: Reddit::Submission.name, dependent: :destroy
  has_many :comments, class_name: Reddit::Comment.name, dependent: :destroy
  has_many :sidebar_votes, class_name: Reddit::SidebarVote.name, dependent: :destroy

  scope :full_text_search, ->(query) { joins(:redditor).where("reddit_redditors.name ILIKE ?", "%#{query}%") }

  before_create :set_fetch_column!

  def set_fetch_column!
    self.fetch_column = "#{redditor.nil? ? '[deleted]' : redditor.name}+#{subreddit.display_name}"
  end

  def label
    redditor_label = redditor&.label || "[deleted]"
    "#{redditor_label} on #{subreddit.label}"
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
    redditor.x.refresh_score! if redditor
  end

  def self.always_include
    [
      :subreddit,
      :redditor
    ]
  end

  def self.fetch_column
    :fetch_column
  end
end