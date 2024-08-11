class VisionDescribePlugin < Plugin
  Reddit::Submission.plugin self, :after_commit, :describe_image

  def self.describe_image(submission)
    return unless submission.present?
    return unless submission.image.attached?
    return if Reddit::VisionLabel.where(context: submission, label: "description").exists?

    raise "RAILS_HOST not set" unless ENV['RAILS_HOST']
    description = Vision.describe(
      "#{ENV['RAILS_HOST']}#{submission.image_url_x512}"
    )&.downcase
    return unless description

    vision_label = Reddit::VisionLabel.create!(
      context: submission,
      label: "description",
      value: description
    )
  rescue => e
    Rails.logger.error "Error describing image for submission #{submission.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end

end