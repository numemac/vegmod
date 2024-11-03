class Reddit::XComment < RedditRecord
  belongs_to :comment, class_name: Reddit::Comment.name

  def label
    "X #{comment.label }"
  end

end