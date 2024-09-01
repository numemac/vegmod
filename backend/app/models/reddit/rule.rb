class Reddit::Rule < RedditRecord
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  def label
    short_name
  end

  def detail_label
    description
  end

  def self.import(subreddit, data)
    return if data["priority"].nil?

    rule = Reddit::Rule.where(subreddit: subreddit, priority: data["priority"]).first
    rule = Reddit::Rule.new if rule.nil?

    rule.subreddit = subreddit
    
    rule.created_utc = data["created_utc"]
    rule.description = data["description"]
    rule.kind = data["kind"]
    rule.priority = data["priority"]
    rule.short_name = data["short_name"]
    rule.violation_reason = data["violation_reason"]

    rule.save! if rule.changed?

    return rule
  end
end