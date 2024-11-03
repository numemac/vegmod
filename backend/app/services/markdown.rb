class Markdown

  attr_accessor :items

  def initialize(items)
    if items.is_a?(String)
      @items = [items]
    else
      @items = items
    end
  end

  def and(item)
    @items << item
    self
  end

  def to_s
    # Join with two spaces to create a line break
    @items.join("  \n")
  end

  {
    bold: ["*", "*"],
    italic: ["**", "**"],
    bold_italic: ["***", "***"],
    strikethrough: ["~~", "~~"],
    spoiler: ["!>", "<!"],
    superscript: ["^(", ")"],
    code: ["`", "`"],
    h1: ["# ", ""],
    h2: ["## ", ""],
    h3: ["### ", ""],
    h4: ["#### ", ""],
    h5: ["##### ", ""],
    h6: ["###### ", ""],
    blockquote: ["> ", ""],
  }.each do |method, (start, finish)|
    define_method(method) do
      @items = @items.map {
        |line| 
        if line == Markdown.hr
          line
        else
          "#{start}#{line}#{finish}"
        end
      }
      self
    end
  end

  def ol
    @items = @items.map.with_index { |line, index| "#{index + 1}. #{line}" }
    self
  end

  def ul
    @items = @items.map { |line| "- #{line}" }
    self
  end

  def link(url)
    @items = @items.map { |line| "[#{line}](#{url})" }
    self
  end

  def subreddit
    @items = @items.map { |line| "r/#{line.gsub('r/', '')}".m.link("https://www.reddit.com/r/#{line}/") }
    self
  end

  def user
    @items = @items.map { |line| "u/#{line.gsub('u/', '')}".m.link("https://www.reddit.com/u/#{line}/") }
    self
  end

  def hr
    @items << Markdown.hr
    self
  end

  def self.hr
    "---"
  end

end