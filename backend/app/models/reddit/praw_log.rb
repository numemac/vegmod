class Reddit::PrawLog < RedditRecord
  include Imageable
  include WebIndexable

  belongs_to :context, polymorphic: true, required: true

  def label 
    action
  end

  def image
    context&.image
  end

  def image_url
    context&.image_url
  end

  def self.full_text_search(query)
    where("action ILIKE ?", "%#{query}%")
  end

end