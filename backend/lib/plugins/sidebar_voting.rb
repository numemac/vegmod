class Plugins::SidebarVoting < Plugins::AbstractPlugin

  def self.title
    "Sidebar Voting"
  end

  def self.description
    "Allows the !sidebar to be managed by the community"
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