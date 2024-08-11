class Reddit::Subreddit < RedditRecord
  has_many :flair_templates, class_name: Reddit::FlairTemplate.name, dependent: :destroy
  has_many :subreddit_redditors, class_name: Reddit::SubredditRedditor.name, dependent: :destroy
  has_many :redditors, through: :subreddit_redditors, class_name: Reddit::Redditor.name
  has_many :submissions, through: :subreddit_redditors, class_name: Reddit::Submission.name
  has_many :comments, through: :subreddit_redditors, class_name: Reddit::Comment.name
  has_many :removal_reasons, class_name: Reddit::RemovalReason.name, dependent: :destroy
  has_many :reports, class_name: Reddit::Report.name, dependent: :destroy

  def label
    "r/#{display_name}"
  end

  def detail_label
    subscribers_formatted = subscribers.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    "#{subscribers_formatted} members"
  end

  def search_removal_reason(substring)
    removal_reasons.find_by("lower(title) LIKE ?", "%#{substring.downcase}%")
  end

  def self.import(data)
    return if data["id"].nil?

    subreddit = Reddit::Subreddit.find_by_external_id(data["id"])
    subreddit = Reddit::Subreddit.new if subreddit.nil?

    subreddit.external_id = data["id"]
    subreddit.name = data["name"]
    subreddit.display_name = data["display_name"]
    subreddit.description = data["description"]
    subreddit.description_html = data["description_html"]
    subreddit.public_description = data["public_description"]
    subreddit.subscribers = data["subscribers"]
    subreddit.over18 = data["over18"]
    subreddit.spoilers_enabled = data["spoilers_enabled"]
    subreddit.can_assign_link_flair = data["can_assign_link_flair"]
    subreddit.can_assign_user_flair = data["can_assign_user_flair"]
  
    subreddit.save! if subreddit.changed?

    if data["submissions"]
      data["submissions"].each do |submission_data|
        Reddit::Submission.import(subreddit, submission_data)
      end
    end

    if data["comments"]
      data["comments"].each do |comment_data|
        Reddit::Comment.import(subreddit, comment_data)
      end
    end

    if data["flair_templates"]
      data["flair_templates"].each do |flair_template_data|
        Reddit::FlairTemplate.import(subreddit, flair_template_data)
      end
    end

    if data["removal_reasons"]
      data["removal_reasons"].each do |removal_reason_data|
        Reddit::RemovalReason.import(subreddit, removal_reason_data)
      end
    end

    if data["reports"]
      existing_report_ids = subreddit.reports.pluck(:id)
      import_report_ids = []
      data["reports"].each do |report_data|
        report = Reddit::Report.import(subreddit, report_data)
        import_report_ids << report.id if report
      end

      # Delete reports that were not imported, must be resolved
      Reddit::Report.where(id: existing_report_ids - import_report_ids).destroy_all
    end

    return subreddit
  end
end