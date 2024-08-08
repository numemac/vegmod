class Subreddit < ApplicationRecord
  has_many :flair_templates
  has_many :subreddit_redditors
  has_many :redditors, through: :subreddit_redditors
  has_many :submissions, through: :subreddit_redditors
  has_many :comments, through: :subreddit_redditors
  has_many :removal_reasons
  has_many :reports

  def label
    "r/#{display_name}"
  end

  def self.import(data)
    return if data["id"].nil?

    subreddit = Subreddit.find_by_external_id(data["id"])
    subreddit = Subreddit.new if subreddit.nil?

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
        Submission.import(subreddit, submission_data)
      end
    end

    if data["comments"]
      data["comments"].each do |comment_data|
        Comment.import(subreddit, comment_data)
      end
    end

    if data["flair_templates"]
      data["flair_templates"].each do |flair_template_data|
        FlairTemplate.import(subreddit, flair_template_data)
      end
    end

    if data["removal_reasons"]
      data["removal_reasons"].each do |removal_reason_data|
        RemovalReason.import(subreddit, removal_reason_data)
      end
    end

    if data["reports"]
      existing_report_ids = subreddit.reports.pluck(:id)
      import_report_ids = []
      data["reports"].each do |report_data|
        report = Report.import(subreddit, report_data)
        import_report_ids << report.id if report
      end

      # Delete reports that were not imported, must be resolved
      Report.where(id: existing_report_ids - import_report_ids).destroy_all
    end

    return subreddit
  end
end