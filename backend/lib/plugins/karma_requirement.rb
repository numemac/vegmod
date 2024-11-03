class Plugins::KarmaRequirement < Plugins::AbstractPlugin

  def self.title
    "Karma Requirement"
  end

  def self.description
    "Specify karma requirements for users to post in your subreddit"
  end

  def self.author
    "vegmod@augu.dev"
  end

  def self.spec
    {
      non_adversarial_karma: {
        type: "integer",
        label: "Non-Adversarial Karma",
        description: "Remove posts from users who have less than this amount of karma from other vegan subreddits",
        default: 0,
        validations: {}
      },
      adversarial_karma: {
        type: "integer",
        label: "Adversarial Karma",
        description: "Remove posts from users who have more than this amount of karma from anti-vegan subreddits",
        default: 50,
        validations: {}
      }
    }
  end

  def conditions_met?
    return false unless @record.is_a?(Reddit::Submission) || @record.is_a?(Reddit::Comment)
    return false unless @config[:non_adversarial_karma].present?
    return false unless @config[:adversarial_karma].present?
    return false unless @record.redditor.x.non_adversarial_score < @config[:non_adversarial_karma].to_i
    return false unless @record.redditor.x.adversarial_score > @config[:adversarial_karma].to_i
    return true
  end

  def execute
    @logger.info "Removing #{@record.class.name} #{@record.id} by u/#{@record.redditor.name} | non-adversarial karma: #{@record.redditor.x.non_adversarial_karma} | adversarial karma: #{@record.redditor.x.adversarial_karma}"
    @record.praw.remove("Karma Requirement", false, nil)
    post_type = @record.is_a?(Reddit::Submission) ? "post" : "comment"
    @record.praw.send_removal_message(
      [
        "Your #{post_type} has been removed because you do not meet the karma requirements for this subreddit.",
        "Please participate in other vegan subreddits to build up your karma and try again later."
      ].join("\n\n")
    )
  end

end