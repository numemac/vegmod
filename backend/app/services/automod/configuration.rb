class Automod::Configuration

  attr_accessor :subreddit, :rules

  RULE_CLASSES = [
    Automod::AccountAge,
    Automod::Announcement,
    Automod::Censor,
    Automod::FilterReported,
    Automod::NegativeKarma
  ]

  def initialize(subreddit)
    @subreddit = subreddit
    @rules = RULE_CLASSES.map { |c| c.new(subreddit) }
  end

  def to_s
    @rules.map(&:to_s).join("  \n" + Automod::Rule.divider + "  \n")
  end

  def as_json(options={})
    @rules.each { |rule|
      [
        rule.class.name.demodulize.underscore,
        rule.as_json
      ]
    }.to_h
  end

end