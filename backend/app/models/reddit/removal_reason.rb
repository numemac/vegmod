class Reddit::RemovalReason < RedditRecord
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  def label
    title
  end

  def detail_label
    message&.truncate(30, omission: "...")
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    removal_reason = Reddit::RemovalReason.find_by_external_id(data["id"])
    removal_reason = Reddit::RemovalReason.new if removal_reason.nil?

    removal_reason.subreddit = subreddit
    
    removal_reason.external_id = data["id"]
    removal_reason.message = data["message"]
    removal_reason.title = data["title"]

    removal_reason.save! if removal_reason.changed?

    return removal_reason
  end
end