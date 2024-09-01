class Reddit::XSubmission < RedditRecord
  belongs_to :submission, class_name: Reddit::Submission.name

  def label
    "X #{submission.label }"
  end

  def detail_label
    submission.detail_label
  end

end