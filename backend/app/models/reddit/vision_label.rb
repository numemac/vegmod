class Reddit::VisionLabel < RedditRecord
  include Imageable

  belongs_to :context, polymorphic: true, required: true
  after_commit :log

  def label 
    # get it from the column, the RedditRecord#label overrides it and we don't want that
    self[:label]
  end

  def detail_label
    value
  end

  def image
    context&.image
  end

  def image_url
    context&.image_url
  end

  def log
    Rails.logger.info "-" * 40
    Rails.logger.info "Created Vision Label:"
    Rails.logger.info "  context_id:   #{context_id}"
    Rails.logger.info "  context_type: #{context_type}"
    Rails.logger.info "  image_url:    #{image_url}"
    Rails.logger.info "  id:           #{id}"
    Rails.logger.info "  label:        #{label}"
    Rails.logger.info "  value:        #{value}"
    Rails.logger.info "-" * 40
  end

end