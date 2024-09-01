class ScoreReportPlugin < Plugin
  Reddit::Comment.plugin self, :after_create, :reply_to_comment

  def self.subreddits
    ["animalhaters", "circlesnip", "vegancirclejerk", "vegancirclejerkchat"]
  end

  # triggered by commenting !karma
  def self.reply_to_comment(comment)
    return unless comment.present?
    return unless comment.body.present?
    return unless comment.body.downcase.include?("!karma")

    redditor = comment.redditor
    return unless redditor.present?
    return if redditor.bot?

    score_report = redditor&.score_report
    unless score_report.present?
      Rails.logger.error "Error generating score report for comment #{comment.id}"
      return
    end

    comment.praw.reply_distinguish_lock(score_report)
  end
end