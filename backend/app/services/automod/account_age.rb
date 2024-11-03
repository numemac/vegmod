class Automod::AccountAge < Automod::Rule

  attr_accessor :subreddit

  def initialize(subreddit)
    @subreddit = subreddit
    stipulate("author").with("account_age", "<#{@config[:minimum_age]}days").with("is_contributor", "false")
    stipulate("action", "remove")
    stipulate("action_reason", "Account is less than 3-days-old.")
    stipulate("comment", "To ensure #{"healthy discussion".m.bold}, we require your Reddit account to be at least 3 days old before participating in our community.")
  end
end