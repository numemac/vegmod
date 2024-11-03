class UserSubreddit < FetchRecord
  belongs_to :user, class_name: User.name
  belongs_to :subreddit, class_name: Reddit::Subreddit.name
end