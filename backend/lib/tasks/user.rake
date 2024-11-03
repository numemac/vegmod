namespace :user do

  task :sync => :environment do
    existing_ids = UserSubreddit.pluck(:id)
    import_ids = []

    Reddit::SubredditRedditor.where(moderator: true).each do |subreddit_redditor|
      users = subreddit_redditor.redditor.users
      users.each do |user|
        import_ids << UserSubreddit.find_or_create_by(
          user: user,
          subreddit: subreddit_redditor.subreddit
        ).id
      end
    end

    destroy_ids = existing_ids - import_ids
    if destroy_ids.any?
      UserSubreddit.where(id: destroy_ids).each do |user_subreddit|
        begin
          Rails.logger.info "Removing moderator privileges from #{user_subreddit.user.name} in #{user_subreddit.subreddit.display_name}"
        rescue => e
          Rails.logger.error e
        end  
        user_subreddit.destroy
      end
    end

    new_ids = import_ids - existing_ids
    if new_ids.any?
      UserSubreddit.where(id: new_ids).each do |user_subreddit|
        begin
          Rails.logger.info "Granted moderator privileges to #{user_subreddit.user.name} in #{user_subreddit.subreddit.display_name}"
        rescue => e
          Rails.logger.error e
        end
      end
    end
  end

end