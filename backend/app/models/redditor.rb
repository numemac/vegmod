class Redditor < ApplicationRecord

  has_many :subreddit_redditors
  has_many :subreddits, through: :subreddit_redditors
  has_many :submissions, through: :subreddit_redditors
  has_many :comments, through: :subreddit_redditors

  def label
    "u/#{name}"
  end

  def self.import(subreddit, data)
    if data.nil? || data["id"].nil?
      SubredditRedditor.find_or_create_by(subreddit: subreddit, redditor: nil)
      return nil
    end

    redditor = Redditor.find_by_external_id(data["id"])
    redditor = Redditor.new if redditor.nil?

    redditor.external_id = data["id"]
    redditor.name = data["name"]
    redditor.created_utc = data["created_utc"]
    redditor.comment_karma = data["comment_karma"]
    redditor.has_verified_email = data["has_verified_email"]
    redditor.icon_img = data["icon_img"]
    redditor.is_employee = data["is_employee"]
    redditor.is_mod = data["is_mod"]
    redditor.is_gold = data["is_gold"]
  
    redditor.save! if redditor.changed?

    SubredditRedditor.find_or_create_by(subreddit: subreddit, redditor: redditor)

    return redditor
  end
end