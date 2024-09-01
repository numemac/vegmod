class Reddit::ModeratorWidget < RedditRecord
  belongs_to :widget, class_name: Reddit::Widget.name
  has_one :subreddit, through: :widget, class_name: Reddit::Subreddit.name

  has_many :moderator_widget_redditors, class_name: Reddit::ModeratorWidgetRedditor.name
end