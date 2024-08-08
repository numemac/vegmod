class Submission < ApplicationRecord
  belongs_to  :subreddit_redditor
  has_one     :subreddit, through: :subreddit_redditor
  has_one     :redditor, through: :subreddit_redditor

  has_many    :comments, as: :parent

  scope :image, -> { where("url LIKE '%.jpg' OR url LIKE '%.jpeg' OR url LIKE '%.png' OR url LIKE '%.gif'") }
  scope :video, -> { where("url LIKE '%.mp4' OR url LIKE '%.webm'") }

  after_save do
    subreddit_redditor.refresh_score!
  end

  def label
    title
  end

  def extname
    # returns "" if url does not have an extension
    # https://i.redd.it/9n2tib68zogd1.png -> .png
    # https://v.redd.it/9n2tib68zogd1 -> ""
    File.extname(url).downcase
  rescue
    ""
  end

  def image?
    %w(.jpg .jpeg .png .gif).include?(extname)
  end

  def video?
    %w(.mp4 .webm).include?(extname)
  end

  def computed
    {
      extname: extname,
      image: image?,
      video: video?
    }
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    submission = Submission.find_by_external_id(data["id"])
    submission = Submission.new if submission.nil?

    redditor = Redditor.import(subreddit, data["author"])
    submission.subreddit_redditor = SubredditRedditor.find_by(subreddit: subreddit, redditor: redditor)
    submission.author_flair_text = data["author_flair_text"]
    submission.created_utc = data["created_utc"]
    submission.distinguished = data["distinguished"]
    submission.edited = data["edited"]
    submission.external_id = data["id"]
    submission.is_original_content = data["is_original_content"]
    submission.is_self = data["is_self"]
    submission.link_flair_template_id = data["link_flair_template_id"]
    submission.link_flair_text = data["link_flair_text"]
    submission.locked = data["locked"]
    submission.name = data["name"]
    submission.num_comments = data["num_comments"]
    submission.over_18 = data["over_18"]
    submission.permalink = data["permalink"]
    # submission.poll_data = data["poll_data"]
    submission.score = data["score"]
    submission.selftext = data["selftext"]
    submission.spoiler = data["spoiler"]
    submission.stickied = data["stickied"]
    submission.title = data["title"]
    submission.upvote_ratio = data["upvote_ratio"]
    submission.url = data["url"]

    submission.save! if submission.changed?

    return submission
  end
end