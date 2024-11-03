class SidebarVotePlugin < OldPlugin
  Reddit::Comment.plugin self, :after_create, :record_vote

  def self.subreddits
    ["animalhaters", "circlesnip", "vegancirclejerk", "vegancirclejerkchat"]
  end

  def self.rank_needed
    5
  end

  # triggered by commenting !sidebar
  def self.record_vote(comment)
    return unless comment.present?
    return unless comment.body.present?
    return unless comment.body.downcase.include?("!sidebar")

    redditor = comment.redditor
    return unless redditor.present?
    return if redditor.bot?

    sidebar_vote = Reddit::SidebarVote.find_or_initialize_by(subreddit_redditor: comment.subreddit_redditor)
    sidebar_vote.submission = comment.submission

    if sidebar_vote && !sidebar_vote.updateable?
      comment.praw.reply_distinguish_lock("You can only vote once per day.")
      return
    end

    if sidebar_vote.save
      sentences = ["Your vote has been recorded."]
      sentences << "There are now #{sidebar_vote.vote_count} votes for this submission."
      sentences << "Your vote will expire in one year or when you vote for another submission."

      votes_needed = sidebar_vote.votes_needed(rank_needed)
      if votes_needed > 0
        sentences << "#{votes_needed} more votes are needed to reach the #{comment.subreddit.display_name} sidebar."
      else
        sentences << "This submission is in or will be added to the #{comment.subreddit.display_name} sidebar within the next hour."
      end

      comment.praw.reply_distinguish_lock(sentences.join(" "))
    else
      error_messages = sidebar_vote.errors.messages.values.flat_map do |messages|
        messages
      end

      if error_messages.any?
        # Join the error messages into a single string
        error_message_string = error_messages.join(" ")

        # Reply to the comment with the error messages
        comment.praw.reply_distinguish_lock(error_message_string)

        # Optionally, log the error messages for debugging purposes
        Rails.logger.error("SidebarVote errors: #{error_message_string}")
      end
    end
  end
end