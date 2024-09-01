class Reddit::PostFlairWidget < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name
end