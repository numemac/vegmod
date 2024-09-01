class Reddit::SidebarVote < RedditRecord
  include Externalable
  include Imageable

  belongs_to :subreddit_redditor, class_name: Reddit::SubredditRedditor.name
  has_one    :subreddit, through: :subreddit_redditor, class_name: Reddit::Subreddit.name
  has_one    :redditor, through: :subreddit_redditor, class_name: Reddit::Redditor.name
  belongs_to :submission, class_name: Reddit::Submission.name

  # validate that the subreddit_redditor's score is above 50
  validate :validate_subreddit_redditor_score

  # validate that the subreddit_redditor's age is at least 1 week
  validate :validate_subreddit_redditor_age

  # validate that the submission is not more than 1 week old
  validate :validate_submission_age

  # validate the post type
  validate :validate_submission_type

  # validate the submission is not NSFW on create
  validate :validate_submission_not_nsfw, on: [:create, :update]

  # sets the category based on the submission type
  # image, link, or self
  # update and create
  before_validation :set_category, on: [:create, :update]

  # votes are valid for 1 year
  scope :non_expired, -> { where("sidebar_votes.created_at > ?", 1.year.ago) }
  scope :expired, -> { where("sidebar_votes.created_at < ?", 1.year.ago) }
  scope :categorized, -> { where.not(category: nil) }
  scope :uncategorized, -> { where(category: nil) }
  scope :valid, -> { non_expired.categorized }
  scope :with_subreddit, ->(subreddit) { includes(:subreddit).where(subreddits: { id: subreddit.id }) }

  def label
    "#{redditor.label}'s vote"
  end

  def detail_label
    "Voted for #{submission.label}"
  end

  def self.detail_association
    :submission
  end

  def external_url
    submission.external_url
  end

  # implements Imageable#image
  def image
    subreddit_redditor.image
  end

  # implements Imageable#image_url
  def image_url
    subreddit_redditor.image_url
  end

  # limit is optional, set nil for no limit
  def self.top(subreddit, category, limit)
    votes = valid.with_subreddit(subreddit).where(category: category).group(:submission_id).count
    submission_ids = votes.keys
    submissions = Reddit::Submission.where(id: submission_ids).index_by(&:id)
    sorted_submissions = submission_ids.map { |id| submissions[id] }
    sorted_submissions = sorted_submissions.first(limit) if limit
    sorted_submissions
  end

  # cannot be updated if updated less than 1 day ago
  def updateable?
    return true if updated_at.nil?
    updated_at < 1.day.ago
  end

  def set_category
    if submission.image_post?
      self.category = "image"
    elsif submission.link_post?
      self.category = "link"
    elsif submission.self_post?
      self.category = "self"
    end
  end

  def rank
    Reddit::SidebarVote.top(subreddit, category, nil).index(submission) + 1
  end

  def vote_count
    Reddit::SidebarVote.where(submission: submission).count
  end

  def votes_needed(goal_rank)
    # Get the submissions ranked up to the goal rank in the category
    ranking_submissions = Reddit::SidebarVote.top(subreddit, category, goal_rank)
    
    # If there are fewer submissions than the goal rank, no votes are needed
    return 0 if ranking_submissions.length < goal_rank
  
    # Get the submission at the goal rank
    rank_submission = ranking_submissions.last
    
    # Get the number of votes for the submission at the goal rank
    rank_submission_votes = Reddit::SidebarVote.where(submission: rank_submission).valid.count
    
    # Calculate the number of votes needed to surpass the submission at the goal rank
    votes_needed = rank_submission_votes + 1 - vote_count
    
    # Ensure the number of votes needed is not negative
    [votes_needed, 0].max
  end

  private

  # must have at least 50 karma in the subreddit
  def validate_subreddit_redditor_score
    minimum_karma = 50
    if subreddit_redditor.score < minimum_karma
      errors.add(:subreddit_redditor, "You need at least #{minimum_karma} karma in #{subreddit.display_name} to vote. You currently have #{subreddit_redditor.score} karma.")
    end
  end

  # must be at least 1 week old
  def validate_subreddit_redditor_age
    minimum_age = 1.week
    if subreddit_redditor.created_at > minimum_age.ago
      activity_start = subreddit_redditor.created_at.strftime("%B %e")
      errors.add(:subreddit_redditor, "You must have been active in #{subreddit.display_name} for at least 1 week to vote. Your activity started on #{activity_start}.")
    end
  end

  # submission must be less than 1 week old
  def validate_submission_age
    maximum_age = 1.week
    if submission.created_at < maximum_age.ago
      submission_start = submission.created_at.strftime("%B %e")
      errors.add(:submission, "The submission must be less than 1 week old to vote. This submission was posted on #{submission_start}.")
    end
  end

  # must be image, link, or self post
  def validate_submission_type
    unless submission.image_post? || submission.link_post? || submission.self_post?
      errors.add(:submission, "The submission must be an image, link, or self post to vote. Gallery and video posts are not eligible.")
    end
  end

  def validate_submission_not_nsfw
    if submission.over_18
      errors.add(:submission, "You cannot vote for an NSFW submission to be featured on the sidebar.")
    end
  end

end