class Automod::FilterReported < Automod::Rule

  attr_accessor :subreddit

  def initialize(subreddit)
    @subreddit = subreddit
    stipulate("reports", 2)
    stipulate("action", "filter")
    stipulate("action_reason", "Multiple reports")
  end
end