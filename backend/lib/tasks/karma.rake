namespace :karma do

  task :month => :environment do
    time_range = 30.days.ago..Time.current
    recent_contributors = Reddit::SubredditRedditor.where(last_contributed_at: time_range)
    recent_contributors.each do |subreddit_redditor|
      comments_30d = subreddit_redditor.comments.where(created_at: time_range)
      submissions_30d = subreddit_redditor.submissions.where(created_at: time_range)
      score_30d = comments_30d.sum(:score) + submissions_30d.sum(:score)
      subreddit_redditor.update!(score_30d: score_30d)
    end

    # set score to 0 for subreddit redditors who have not contributed in the last 30 days
    Reddit::SubredditRedditor.where(
      "last_contributed_at < ? OR last_contributed_at IS NULL",
      30.days.ago
    ).update_all(score_30d: 0)
  end

end