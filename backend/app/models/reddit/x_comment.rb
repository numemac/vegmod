class Reddit::XComment < RedditRecord
  belongs_to :comment, class_name: Reddit::Comment.name

  def label
    "X #{comment.label }"
  end

  def detail_label
    comment.detail_label
  end

end