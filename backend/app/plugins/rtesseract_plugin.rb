class RtesseractPlugin < Plugin
  Reddit::Submission.plugin self, :after_commit, :extract_text

  def self.clean_text(text)
    # remove newlines
    text = text.gsub("\n", " ")

    # remove multiple spaces
    text = text.gsub(/\s+/, " ")

    # remove leading and trailing spaces
    text = text.strip

    return text
  end

  def self.extract_text(submission)
    return unless submission.present?
    return unless submission.image.attached?
    return if Reddit::VisionLabel.where(context: submission, label: "rtesseract").exists?

    rtesseract = nil
    # create temp file for submission image
    file_path = "/tmp/submission_image_#{submission.id}#{submission.extname}"
    File.open(file_path, "wb") do |f|
      submission.image.download do |chunk|
        f.write(chunk)
      end
    end

    # extract text from image
    rtesseract = RTesseract.new(file_path).to_s

    # delete temp file
    File.delete(file_path)

    return unless rtesseract.present?

    rtesseract = clean_text(rtesseract)

    # create vision label for extracted text
    vision_label = Reddit::VisionLabel.create!(
      context: submission,
      label: "rtesseract",
      value: rtesseract
    )

  rescue => e
    Rails.logger.error "Error running RTesseract for submission #{submission.id}"
    Rails.logger.error "Error class: #{e.class}"
    Rails.logger.error "Error message: #{e.message}"
    Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
  end

end