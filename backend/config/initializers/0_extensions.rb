module Extensions
  module String
    def m
      Markdown.new(self)
    end
  end

  module Array
    def m
      Markdown.new(self)
    end
  end

end

String.include Extensions::String
Array.include Extensions::Array