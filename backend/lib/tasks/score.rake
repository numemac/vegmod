namespace :score do

  # records what the score is 24 hours after the comment or submission was created
  task :freeze_24h => :environment do
    comments = Reddit::XComment.where(score_24h: nil).where("created_at < ?", 24.hours.ago)
    comments.each { |x| x.update(score_24h: x.comment.score) }

    submissions = Reddit::XSubmission.where(score_24h: nil).where("created_at < ?", 24.hours.ago)
    submissions.each { |x| x.update(score_24h: x.submission.score) }
  end
end