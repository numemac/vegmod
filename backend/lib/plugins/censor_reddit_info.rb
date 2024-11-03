class Plugins::CensorRedditInfo < Plugins::AbstractPlugin

  def self.title
    "Censor Reddit Info"
  end

  def self.description
    "Remove images with visible Reddit user or subreddit information"
  end

  def self.author
    "vegmod@augu.dev"
  end

  def self.spec
    {}
  end

  def conditions_met?
    return false unless @record.is_a?(Reddit::Submission)
    return true
  end

  def execute

  end

end