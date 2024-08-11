class Reddit::Comment < RedditRecord
  include Imageable

  belongs_to  :subreddit_redditor, class_name: Reddit::SubredditRedditor.name
  has_one     :subreddit, class_name: Reddit::Subreddit.name, through: :subreddit_redditor
  has_one     :redditor, class_name: Reddit::Redditor.name, through: :subreddit_redditor

  belongs_to  :parent, polymorphic: true, optional: true

  has_many    :comments, class_name: Reddit::Comment.name, as: :parent
  has_many    :praw_logs, class_name: Reddit::PrawLog.name, as: :context

  after_save do
    subreddit_redditor.refresh_score!
  end

  def label
    body
  end

  def self.detail_association
    :subreddit_redditor
  end

  def image
    redditor&.image
  end

  def image_url
    redditor&.image_url
  end

  def praw
    Praw::Comment.new(self)
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    comment = Reddit::Comment.find_by_external_id(data["id"])
    comment = Reddit::Comment.new if comment.nil?

    redditor = Reddit::Redditor.import(subreddit, data["author"])
    comment.subreddit_redditor = Reddit::SubredditRedditor.find_by(subreddit: subreddit, redditor: redditor)
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
        comment.parent = Reddit::Submission.find_by_external_id(comment.parent_external_id.split("_")[1])
      elsif comment.parent_external_id.start_with? "t1_"
        comment.parent = Reddit::Comment.find_by_external_id(comment.parent_external_id.split("_")[1])
      end
    end

    comment.save! if comment.changed?

    return comment
  end
end