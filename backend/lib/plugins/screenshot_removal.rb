class Plugins::ScreenshotRemoval < Plugins::AbstractPlugin

  def self.title
    "Screenshot Removal"
  end

  def self.description
    "Remove screenshots of social media and messaging platforms"
  end

  def self.author
    "vegmod@augu.dev"
  end

  def self.spec
    {
      rule_name: {
        type: "string",
        label: "Rule Name",
        description: "The name of the rule",
        default: "No social media or messaging screenshots",
        validations: {}
      },
      forbidden_screenshots:{
        type: "string",
        label: "Forbidden Screenshots",
        description: "Specify what types of screenshots are not allowed",
        default: "Reddit, Lemmy, kbin, TikTok, Twitter, Threads, Mastodon, Facebook, Instagram, YouTube, Discord, iMessage, SMS, Matrix, Snapchat, Telegram, WeChat, Whatsapp, Medium, Quora, Twitch, LinkedIn, Tumblr, blogs, personal websites",
        validations: {}
      },
      permitted_screenshots: {
        type: "string",
        label: "Permitted Screenshots",
        description: "Provide clarity on what types of screenshots are allowed",
        default: "news articles, business websites, petitions, fundraisers, political campaigns, search results, reviews, e-commerce, and informational pages",
        validations: {}
      },
      helpful_suggestion: {
        type: "string",
        label: "Helpful Suggestion",
        description: "Offer an alternative subreddit to post the content",
        default: "You may post social media and messaging screenshots to r/animalhaters.",
        multiline: true,
        validations: {}
      }
      # removal_message: {
      #   type: "string",
      #   label: "Removal Message",
      #   description: "The message to send to users when their post is removed",
      #   default: [
      #     "We remove all screenshots of Reddit, Lemmy, kbin, TikTok, Twitter, Threads, Mastodon, Facebook, Instagram, YouTube, Discord, iMessage, SMS, Matrix, Snapchat, Telegram, WeChat, Whatsapp, Medium, Quora, Twitch, LinkedIn, Tumblr, blogs, personal websites, etc.",
      #     "We permit screenshots of news articles, business websites, petitions, fundraisers, political campaigns, search results, reviews, e-commerce, and informational pages."          
      #   ].m.to_s,
      #   validations: {}
      # }
    }
  end

  def conditions_met?
    return false unless @record.is_a?(Reddit::Submission)
    return true
  end

  def execute

  end

end