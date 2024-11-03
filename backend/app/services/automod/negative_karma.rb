class Automod::NegativeKarma < Automod::Rule

  attr_accessor :subreddit

  def initialize(subreddit)
    @subreddit = subreddit
    stipulate("author").with("combined_subreddit_karma", "<-5").with("is_contributor", "false")
    stipulate("action", "filter")
    stipulate("action_reason", "Negative karma")
  end
end