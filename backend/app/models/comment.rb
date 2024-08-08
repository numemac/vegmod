class Comment < ApplicationRecord
  belongs_to  :subreddit_redditor
  has_one     :subreddit, through: :subreddit_redditor
  has_one     :redditor, through: :subreddit_redditor

  belongs_to  :parent, polymorphic: true, optional: true

  has_many :comments, as: :parent

  after_save do
    subreddit_redditor.refresh_score!
  end

  def label
    body
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    comment = Comment.find_by_external_id(data["id"])
    comment = Comment.new if comment.nil?

    redditor = Redditor.import(subreddit, data["author"])
    comment.subreddit_redditor = SubredditRedditor.find_by(subreddit: subreddit, redditor: redditor)
    comment.body = data["body"]
    comment.body_html = data["body_html"]
    comment.created_utc = data["created_utc"]
    comment.distinguished = data["distinguished"]
    comment.edited = data["edited"]
    comment.external_id = data["id"]
    comment.is_submitter = data["is_submitter"]
    comment.link_id = data["link_id"]
    comment.parent_external_id = data["parent_id"]
    comment.permalink = data["permalink"]
    comment.score = data["score"]
    comment.stickied = data["stickied"]

    if comment.parent.nil? && comment.parent_external_id
      if comment.parent_external_id.start_with? "t3_"
        comment.parent = Submission.find_by_external_id(comment.parent_external_id.split("_")[1])
      elsif comment.parent_external_id.start_with? "t1_"
        comment.parent = Comment.find_by_external_id(comment.parent_external_id.split("_")[1])
      end
    end

    comment.save! if comment.changed?

    return comment
  end
end