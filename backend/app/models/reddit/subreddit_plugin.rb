class Reddit::SubredditPlugin < RedditRecord
  belongs_to :plugin, class_name: 'Plugin'
  belongs_to :subreddit, class_name: 'Reddit::Subreddit'

  validates :plugin, presence: true
  validates :subreddit, presence: true
  validates :enabled, inclusion: { in: [true, false] }
  validates :executions, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :failures, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.always_include
    [:plugin]
  end
end