class RemovalReason < ApplicationRecord
  belongs_to :subreddit

  def label
    title
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    removal_reason = RemovalReason.find_by_external_id(data["id"])
    removal_reason = RemovalReason.new if removal_reason.nil?

    removal_reason.subreddit = subreddit
    
    removal_reason.external_id = data["id"]
    removal_reason.message = data["message"]
    removal_reason.title = data["title"]

    removal_reason.save! if removal_reason.changed?

    return removal_reason
  end
end