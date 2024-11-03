class Plugins::KarmaCommand < Plugins::AbstractPlugin

  def self.title
    "Karma Command"
  end

  def self.description
    "Users can reply !karma to see their subreddit karma"
  end

  def self.author
    "vegmod@augu.dev"
  end

  def self.spec
    {}
  end

  def conditions_met?
    return false unless @record.is_a?(Reddit::Comment)
    return true
  end

  def execute

  end

end