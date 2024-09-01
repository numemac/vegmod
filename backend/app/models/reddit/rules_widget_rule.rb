class Reddit::RulesWidgetRule < RedditRecord
  belongs_to :rules_widget, class_name: Reddit::RulesWidget.name
  has_one :subreddit, through: :rules_widget, class_name: Reddit::Subreddit.name
  belongs_to :rule, class_name: Reddit::Rule.name
end