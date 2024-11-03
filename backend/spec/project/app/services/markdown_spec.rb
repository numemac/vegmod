require 'rails_helper'

describe Markdown do

  context "when using the markdown service" do
    it "can create a markdown string" do
      markdown = Markdown.new("Hello, world!")
      expect(markdown.to_s).to eq("Hello, world!")
    end

    it "can create a markdown string with a line break" do
      markdown = Markdown.new("Hello, world!").and("Goodbye, world!")
      expect(markdown.to_s).to eq("Hello, world!  \nGoodbye, world!")
    end

    it "can create a bold markdown string" do
      markdown = Markdown.new("Hello, world!").bold
      expect(markdown.to_s).to eq("*Hello, world!*")
    end

    it "can create an italic markdown string" do
      markdown = Markdown.new("Hello, world!").italic
      expect(markdown.to_s).to eq("**Hello, world!**")
    end

    it "can create a bold italic markdown string" do
      markdown = Markdown.new("Hello, world!").bold_italic
      expect(markdown.to_s).to eq("***Hello, world!***")
    end

    it "can create a strikethrough markdown string" do
      markdown = Markdown.new("Hello, world!").strikethrough
      expect(markdown.to_s).to eq("~~Hello, world!~~")
    end

    it "can create a spoiler markdown string" do
      markdown = Markdown.new("Hello, world!").spoiler
      expect(markdown.to_s).to eq("!>Hello, world!<!")
    end

    it "can create a superscript markdown string" do
      markdown = Markdown.new("Hello, world!").superscript
      expect(markdown.to_s).to eq("^(Hello, world!)")
    end

    it "can create a code markdown string" do
      markdown = Markdown.new("Hello, world!").code
      expect(markdown.to_s).to eq("`Hello, world!`")
    end

    [1, 2, 3, 4, 5, 6].each do |level|
      it "can create a h#{level} markdown string" do
        markdown = Markdown.new("Hello, world!").send("h#{level}")
        expect(markdown.to_s).to eq("#{"#" * level} Hello, world!")
      end
    end

    it "can create a blockquote markdown string" do
      markdown = Markdown.new("Hello, world!").blockquote
      expect(markdown.to_s).to eq("> Hello, world!")
    end

    it "can create an ordered list markdown string" do
      markdown = Markdown.new("First item").and("Second item").and("Third item").ol
      expect(markdown.to_s).to eq("1. First item  \n2. Second item  \n3. Third item")
    end

    it "can create an unordered list markdown string" do
      markdown = Markdown.new("Hello, world!").ul
      expect(markdown.to_s).to eq("- Hello, world!")
    end

    it "can create a link markdown string" do
      markdown = Markdown.new("Hello, world!").link("https://example.com")
      expect(markdown.to_s).to eq("[Hello, world!](https://example.com)")
    end

    it "can create a subreddit markdown string" do
      markdown = Markdown.new("vegan").subreddit
      expect(markdown.to_s).to eq("[r/vegan](https://www.reddit.com/r/vegan/)")
    end

    it "can create a user markdown string" do
      markdown = Markdown.new("Numerous-Macaroon224").user
      expect(markdown.to_s).to eq("[u/Numerous-Macaroon224](https://www.reddit.com/u/Numerous-Macaroon224/)")
    end

    it "can create a horizontal rule markdown string" do
      markdown = Markdown.new("Hello, world!").hr
      expect(markdown.to_s).to eq("Hello, world!  \n---")
    end
  end
end