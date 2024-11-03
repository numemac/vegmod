class Plugin < FetchRecord
  has_many :subreddit_plugins, class_name: 'Reddit::SubredditPlugin', dependent: :destroy
  has_many :subreddits, class_name: 'Reddit::Subreddit', through: :subreddit_plugins

  def default_config
    # klass (str) to class
    klass.constantize.default_config
  end
end