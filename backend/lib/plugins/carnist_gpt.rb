class Plugins::CarnistGpt < Plugins::AbstractPlugin

  def self.title
    "Carnist GPT"
  end

  def self.description
    "Novelty chatbot that impersonates a carnist"
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