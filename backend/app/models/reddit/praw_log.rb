class Reddit::PrawLog < RedditRecord
  include Imageable

  belongs_to :context, polymorphic: true, required: true

  def label 
    action
  end

  def detail_association
    :context
  end

  def image
    context&.image
  end

  def image_url
    context&.image_url
  end

end