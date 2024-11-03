class Reddit::Report < RedditRecord
  belongs_to :content, polymorphic: true
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  def label
    "Reported: #{content.label}"
  end

  def self.import(subreddit, data)
    return if data["id"].nil?
    return if data["_type"].nil?

    valid_types = ["Comment", "Submission"]
    raise "Invalid type: #{data["_type"]}" unless valid_types.include?(data["_type"])

    content = nil
    if data["_type"] == "Comment"
      content = Reddit::Comment.import(subreddit, data)
    elsif data["_type"] == "Submission"
      content = Reddit::Submission.import(subreddit, data)
    end

    return if content.nil?

    report = Reddit::Report.where(content: content, subreddit: subreddit)
    return report.first if report.any?
  
    return Reddit::Report.create!(content: content, subreddit: subreddit)
  end
end