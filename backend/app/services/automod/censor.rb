class Automod::Censor < Automod::Rule

  attr_accessor :subreddit

  SLURS = [
    "bitch",
    "chink",
    "cuck",
    "cuckold",
    "fag",
    "fagget", 
    "faggot", 
    "fatass", 
    "femoid", 
    "gypsy", 
    "kike", 
    "libtard",
    "meatard",
    "nig", 
    "nigga",
    "nigger", 
    "nigguh", 
    "niglet", 
    "nigglet", 
    "paki",
    "pussy", 
    "queerbait", 
    "retard", 
    "shemale", 
    "shithole", 
    "skank",
    "tard",
    "trannie", 
    "tranny", 
    "wigger"
  ]

  def initialize(subreddit)
    @subreddit = subreddit
    stipulate("title+body (includes-word, regex)", list_str)
    stipulate("action", "remove")
    stipulate("action_reason", "Slur")
  end

  def list_str
    items = SLURS + SLURS.map(&:pluralize).uniq!
    "[#{items.map { |s| "\"#{s}\"" }.join(", ")}]"
  end

end