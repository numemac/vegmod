class Reddit::ModeratorWidgetRedditor < RedditRecord
  belongs_to :moderator_widget, class_name: Reddit::ModeratorWidget.name
  belongs_to :redditor, class_name: Reddit::Redditor.name

  has_one :subreddit, through: :moderator_widget, class_name: Reddit::Subreddit.name
end