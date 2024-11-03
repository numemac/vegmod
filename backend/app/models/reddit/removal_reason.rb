class Reddit::RemovalReason < RedditRecord
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  scope :full_text_search, ->(query) { where("title ILIKE ?", "%#{query}%") }

  def label
    title
  end

  # implements Externalable#external_url
  def external_url
    "https://www.reddit.com/r/#{subreddit.display_name}/about/removal"
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