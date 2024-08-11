require 'open-uri'

class Reddit::Redditor < RedditRecord
  include Imageable

  has_many :subreddit_redditors, class_name: Reddit::SubredditRedditor.name
  has_many :subreddits, class_name: Reddit::Subreddit.name, through: :subreddit_redditors
  has_many :submissions, class_name: Reddit::Submission.name, through: :subreddit_redditors
  has_many :comments, class_name: Reddit::Comment.name, through: :subreddit_redditors

  after_create :attach_icon!

  def label
    "u/#{name}"
  end

  def detail_label
    "Redditor since #{created}"
  end

  def created
    if created_utc.nil?
      "unknown"
    else
      Time.at(created_utc).strftime("%B %d, %Y")
    end
  end

  def attach_icon!
    if icon_img.present? && !image.attached?
      uri = URI.open(
        icon_img,
        "User-Agent" => ENV['REDDIT_USER_AGENT']
      )

      sleep 1 # respect reddit's rate limit

      # do this synchronously to avoid a race issue
      # with vision plugin
      blob = ActiveStorage::Blob.create_and_upload!(
        io: uri, 
        filename: "redditor_icon_#{name}.#{extname}"
      )
      blob.analyze
      image.attach(blob)
    end
  rescue => e
    puts "Error attaching icon for #{name} with url #{icon_img}: #{e.message}"
  end

  def extname
    if icon_img.nil?
      return ""
    end
    # returns "" if url does not have an extension
    # https://i.redd.it/9n2tib68zogd1.png -> .png
    # https://v.redd.it/9n2tib68zogd1 -> ""
    File.extname(icon_img).downcase
  rescue
    ""
  end

  def self.import(subreddit, data)
    if data.nil? || data["id"].nil?
      Reddit::SubredditRedditor.find_or_create_by(subreddit: subreddit, redditor: nil)
      return nil
    end

    redditor = Reddit::Redditor.find_by_external_id(data["id"])
    redditor = Reddit::Redditor.new if redditor.nil?

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

    Reddit::SubredditRedditor.find_or_create_by(subreddit: subreddit, redditor: redditor)

    return redditor
  end
end