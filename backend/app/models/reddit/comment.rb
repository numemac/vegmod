class Reddit::Comment < RedditRecord
  include Externalable
  include Imageable

  belongs_to  :subreddit_redditor, class_name: Reddit::SubredditRedditor.name
  has_one     :subreddit, class_name: Reddit::Subreddit.name, through: :subreddit_redditor
  has_one     :redditor, class_name: Reddit::Redditor.name, through: :subreddit_redditor
  has_one     :x, class_name: Reddit::XComment.name, dependent: :destroy

  belongs_to  :parent, polymorphic: true, optional: true

  has_many    :comments, class_name: Reddit::Comment.name, as: :parent
  has_many    :praw_logs, class_name: Reddit::PrawLog.name, as: :context

  after_save do
    subreddit_redditor.refresh_score!
  end

  after_create do
    create_x!
  end

  def label
    body
  end

  def self.detail_association
    :subreddit_redditor
  end

  # implements Imageable#image
  def image
    redditor&.image
  end

  # implements Imageable#image_url
  def image_url
    redditor&.image_url
  end

  # implements Externalable#external_url
  def external_url
    "https://www.reddit.com#{permalink}"
  end

  def praw
    Praw::Comment.new(self)
  end

  # For Carnist-GPT
  def chain_item
    {
      id: id,
      external_id: external_id,
      body: body,
      redditor: redditor
    }
  end

  # For Carnist-GPT
  def chain
    if parent
      parent.chain + [chain_item]
    else
      [chain_item]
    end
  end

  # This is a recursive function that will return the submission that this comment belongs to.
  # It will keep going up the chain of parents until it finds a submission.
  # Don't use it excessively, as it will make a lot of database queries.
  def submission
    p = parent
    if p.is_a? Reddit::Submission
      p
    elsif p.is_a? Reddit::Comment
      p.submission
    elsif p.nil?
      nil
    else
      raise "Unknown parent type: #{p.class}"
    end
  end

  def create_x!
    Reddit::XComment.find_or_create_by!(comment: self)
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