namespace :adjust do

  # 2024-09-09
  task :last_contributed_at => :environment do
    Reddit::SubredditRedditor.all.each do |subreddit_redditor|
      last_comment = subreddit_redditor.comments.order(created_at: :desc).first
      last_submission = subreddit_redditor.submissions.order(created_at: :desc).first
      last_contributed_at = [last_comment, last_submission].compact.max_by(&:created_at)
      subreddit_redditor.update!(last_contributed_at: last_contributed_at&.created_at)
    end
  end

end