class Reddit::Submission < RedditRecord
  include Externalable
  include Imageable
  include Videoable
  include WebIndexable

  belongs_to  :subreddit_redditor, class_name: Reddit::SubredditRedditor.name
  has_one     :subreddit, class_name: Reddit::Subreddit.name, through: :subreddit_redditor
  has_one     :redditor, class_name: Reddit::Redditor.name, through: :subreddit_redditor
  has_one     :x, class_name: Reddit::XSubmission.name, dependent: :destroy

  has_many    :comments, class_name: Reddit::Comment.name, as: :parent
  has_many    :vision_labels, class_name: Reddit::VisionLabel.name, as: :context
  has_many    :praw_logs, class_name: Reddit::PrawLog.name, as: :context
  has_many    :sidebar_votes, class_name: Reddit::SidebarVote.name, dependent: :destroy

  scope :image, -> { where("url LIKE '%.jpg' OR url LIKE '%.jpeg' OR url LIKE '%.png' OR url LIKE '%.gif'") }
  scope :video, -> { where("url LIKE '%.mp4' OR url LIKE '%.webm'") }

  scope :full_text_search, ->(query) { where("title ILIKE :query OR selftext ILIKE :query", query: "%#{query}%") }

  after_create do
    create_x!
    subreddit_redditor.update!(last_contributed_at: created_at)
    subreddit_redditor.refresh_score!
    attach_image!
    attach_video!
  end

  after_save do  
    subreddit_redditor.refresh_score! if saved_change_to_score?
  end

  def label
    title
  end

  # implements Externalable#external_url
  def external_url
    "https://www.reddit.com#{permalink}"
  end

  def extname
    if url.nil?
      return ""
    end
    # returns "" if url does not have an extension
    # https://i.redd.it/9n2tib68zogd1.png -> .png
    # https://v.redd.it/9n2tib68zogd1 -> ""
    File.extname(url).downcase
  rescue
    ""
  end

  def praw
    Praw::Submission.new(self)
  end

  def image_post?
    extname.in? [".jpg", ".jpeg", ".png", ".gif"]
  end

  def video_post?
    extname.in? [".mp4", ".webm", "mpeg"]
  end

  def self_post?
    is_self
  end

  def link_post?
    !image_post? && !video_post? && !is_self
  end

  def attach_image!
    return unless image_post? && !image.attached?
    puts "[Reddit::Submission] iid=#{id} image_post?=#{image_post?} image.attached?=#{image.attached?} image_url=#{image_url} url=#{url} ATTACHING IMAGE"
    uri = URI.open(url, "User-Agent" => ENV['REDDIT_USER_AGENT'])
    sleep 1 # respect reddit's rate limit
    
    # do this synchronously to avoid a race issue
    # with vision plugin
    blob = ActiveStorage::Blob.create_and_upload!(
      io: uri, 
      filename: "submission_media_#{id}.#{extname}"
    )
    blob.analyze
    image.attach(blob)
  rescue => e
    puts "Error attaching image for #{name} with url #{url}: #{e.message}"
  end

  def attach_video!
    return unless video_post? && !video.attached?
    uri = URI.open(url, "User-Agent" => ENV['REDDIT_USER_AGENT'])
    sleep 1 # respect reddit's rate limit
    video.attach(io: uri, filename: "submission_video_#{name}.#{extname}")

    save!
  rescue => e
    puts "Error attaching video for #{name} with url #{url}: #{e.message}"
  end

  def image_rtesseract
    return unless image_post?
    
    rtesseract = vision_labels.find_by(label: "rtesseract")
    return if rtesseract.nil?

    rtesseract.value
  end

  # For Carnist-GPT
  def chain_item
    {
      id: id,
      external_id: external_id,
      body: "#{title}\n\n#{image_rtesseract || selftext}",
      redditor: redditor
    }
  end

  # For Carnist-GPT
  def chain
    # submission has no parents
    [chain_item]
  end

  # Helper to match the interface of Reddit::Comment
  def submission
    self
  end

  def create_x!
    Reddit::XSubmission.find_or_create_by!(submission: self)
  end

  def self.always_include
    [:redditor, :subreddit, :vision_labels]
  end

  def self.computed_fields
    [:image_url]
  end

  def self.fetch_column
    :external_id
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    submission = Reddit::Submission.find_by_external_id(data["id"])
    submission = Reddit::Submission.new if submission.nil?

    redditor = Reddit::Redditor.import(subreddit, data["author"])
    submission.subreddit_redditor = Reddit::SubredditRedditor.find_by(subreddit: subreddit, redditor: redditor)
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