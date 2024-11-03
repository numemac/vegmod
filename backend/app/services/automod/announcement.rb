class Automod::Announcement < Automod::Rule

  attr_accessor :subreddit

  def initialize(subreddit)
    @subreddit = subreddit

    stipulate("type", "submission")
    stipulate("comment", 
      [
        "PSA 2024-09-01:".m.h3,
        [
          "You may cast your vote to feature any image post in our sidebar.",
          "To do so, reply !sidebar anywhere in its comment section."
        ].m.ul.hr,
        "Rule breakers will be used for entertainment:".m.h3,
        @subreddit.rules.map { |rule| rule.short_name.m.link("https://www.reddit.com/r/#{rule.subreddit.display_name}/wiki/rules/#") }.m.ol.hr,
        "Explore our vegan safe spaces:".m.h3,
        [
          "circlesnip",
          "vegancirclejerk",
          "vegancirclejerkchat"
        ].m.subreddit.ul
      ]
    )
  end
end