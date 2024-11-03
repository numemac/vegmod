class Reddit::XSubmission < RedditRecord
  belongs_to :submission, class_name: Reddit::Submission.name

  def label
    "X #{submission.label }"
  end

end