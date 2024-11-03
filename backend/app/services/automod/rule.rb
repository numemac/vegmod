class Automod::Rule
  attr_accessor :stipulations

  def initialize
    @stipulations = []
  end

  def stipulate(type, value=[])
    stipulation = Stipulation.new(type, value)
    @stipulations ||= []
    @stipulations << stipulation
    stipulation
  end

  def to_s
    @stipulations.map(&:to_s).join("  \n")
  end

  def self.divider
    "---"
  end

  def self.indent
    "    "
  end

  class Stipulation
    attr_accessor :type, :value

    def initialize(type, value=[])
      @type = type
      @value = value.is_a?(Array) ? value : [value]
    end

    # used like:
    # stipulate("author") << (
    #   stipulate("account_age") << "1 day"
    # )
    def with(type, value)
      @value << Stipulation.new(type, value)
      self
    end

    def to_s
      if @value.length > 1
        value_lines = @value.map(&:to_s).join("  \n").split("\n").map(&:rstrip)
        type_appendage = @value.all? { |v| v.is_a?(Automod::Rule::Stipulation) } ? ":  \n" : ": |  \n"
        @type + type_appendage + value_lines.map { |line| Automod::Rule.indent + line }.join("  \n")
      elsif value.length == 1
        "#{@type}: #{@value.first.to_s}"
      else
        raise "Stipulation has no value"
      end
    end
  end

end