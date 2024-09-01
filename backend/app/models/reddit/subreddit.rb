class Reddit::Subreddit < RedditRecord
  include Externalable

  has_many :flair_templates, class_name: Reddit::FlairTemplate.name, dependent: :destroy
  has_many :subreddit_redditors, class_name: Reddit::SubredditRedditor.name, dependent: :destroy
  has_many :redditors, through: :subreddit_redditors, class_name: Reddit::Redditor.name
  has_many :submissions, through: :subreddit_redditors, class_name: Reddit::Submission.name
  has_many :comments, through: :subreddit_redditors, class_name: Reddit::Comment.name
  has_many :removal_reasons, class_name: Reddit::RemovalReason.name, dependent: :destroy
  has_many :reports, class_name: Reddit::Report.name, dependent: :destroy
  has_many :rules, class_name: Reddit::Rule.name, dependent: :destroy
  
  # comments and submission have praw_logs, assign those to the subreddit that has the comment/submission
  has_many :praw_comments, through: :comments, source: :praw_logs, class_name: Reddit::PrawLog.name
  has_many :praw_submissions, through: :submissions, source: :praw_logs, class_name: Reddit::PrawLog.name

  has_many :widgets, class_name: Reddit::Widget.name, dependent: :destroy

  def label
    "r/#{display_name}"
  end

  def detail_label
    subscribers_formatted = subscribers.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    "#{subscribers_formatted} members"
  end

  def search_removal_reason(substring)
    removal_reasons.find_by("lower(title) LIKE ?", "%#{substring.downcase}%")
  end

  def external_url
    "https://www.reddit.com/r/#{display_name}"
  end

  def sample_comments
    comments.last_week.order(score: :desc).limit(10)
  end

  def default_metric
    metrics.find_by(measure: "new", unit: "comments", interval: 1.hour) || metrics.first
  end

  def praw
    Praw::Subreddit.new(self)
  end

  def self.hidden_attributes
    [
      :can_assign_link_flair,
      :can_assign_user_flair,
      :created_utc,
      :description,
      :description_html,
      :name,
      :spoilers_enabled,
    ]
  end

  def self.import(data)
    return if data["id"].nil?

    subreddit = Reddit::Subreddit.find_by_external_id(data["id"])
    subreddit = Reddit::Subreddit.new if subreddit.nil?

    subreddit.external_id = data["id"]
    subreddit.name = data["name"]
    subreddit.display_name = data["display_name"]
    subreddit.description = data["description"]
    subreddit.description_html = data["description_html"]
    subreddit.public_description = data["public_description"]
    subreddit.subscribers = data["subscribers"]
    subreddit.over18 = data["over18"]
    subreddit.spoilers_enabled = data["spoilers_enabled"]
    subreddit.can_assign_link_flair = data["can_assign_link_flair"]
    subreddit.can_assign_user_flair = data["can_assign_user_flair"]
  
    subreddit.save! if subreddit.changed?

    if data["submissions"]
      data["submissions"].each do |submission_data|
        Reddit::Submission.import(subreddit, submission_data)
      end
    end

    if data["comments"]
      # sort to ensure parent comments are created before child comments
      data["comments"].sort_by { |c| c["created_utc"] || 0 }.each do |comment_data|
        Reddit::Comment.import(subreddit, comment_data)
      end
    end

    if data["flair_templates"]
      data["flair_templates"].each do |flair_template_data|
        Reddit::FlairTemplate.import(subreddit, flair_template_data)
      end
    end

    if data["removal_reasons"]
      data["removal_reasons"].each do |removal_reason_data|
        Reddit::RemovalReason.import(subreddit, removal_reason_data)
      end
    end

    if data["rules"]
      existing_rule_priorities = subreddit.rules.pluck(:priority)
      import_rule_priorities = []
      data["rules"].each do |rule_data|
        rule = Reddit::Rule.import(subreddit, rule_data)
        import_rule_priorities << rule.priority if rule
      end

      # Delete rules that were not imported, must be resolved
      Reddit::Rule.where(
        subreddit: subreddit,
        priority: (
          existing_rule_priorities - import_rule_priorities
        )
      ).destroy_all
    end

    if data["widgets_sidebar"]
      existing_widget_ids = subreddit.widgets.pluck(:id)
      import_widget_ids = []
      data["widgets_sidebar"].each_with_index do |widget_data, order|
        widget = Reddit::Widget.import(subreddit, widget_data, order)
        import_widget_ids << widget.id if widget
      end
      
      # Delete widgets that were not imported, must be resolved
      Reddit::Widget.where(
        subreddit: subreddit,
        id: (
          existing_widget_ids - import_widget_ids
        )
      ).destroy_all
    end

    return subreddit
  end
end