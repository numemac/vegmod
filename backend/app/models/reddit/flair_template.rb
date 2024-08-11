class Reddit::FlairTemplate < RedditRecord
  belongs_to :subreddit, class_name: Reddit::Subreddit.name

  # "allowable_content": "text",
  # "text": "custom",
  # "text_color": "dark",
  # "mod_only": false,
  # "background_color": "#dadada",
  # "id": "dc3e0eb8-23a3-11ec-b70d-8630e08d49ce",
  # "css_class": "",
  # "max_emojis": 10,
  # "richtext": [
  #     {
  #         "e": "text",
  #         "t": "custom"
  #     }
  # ],
  # "text_editable": true,
  # "override_css": false,
  # "type": "richtext"

  def label
    text
  end

  def detail_label
    external_id
  end

  def self.import(subreddit, data)
    return if data["id"].nil?

    flair_template = Reddit::FlairTemplate.find_by_external_id(data["id"])
    flair_template = Reddit::FlairTemplate.new if flair_template.nil?

    flair_template.subreddit = subreddit
    
    flair_template.allowable_content = data["allowable_content"]
    flair_template.text = data["text"]
    flair_template.text_color = data["text_color"]
    flair_template.mod_only = data["mod_only"]
    flair_template.background_color = data["background_color"]
    flair_template.external_id = data["id"]
    flair_template.css_class = data["css_class"]
    flair_template.max_emojis = data["max_emojis"]
    flair_template.richtext = data["richtext"]
    flair_template.text_editable = data["text_editable"]
    flair_template.override_css = data["override_css"]
    flair_template.external_type = data["type"]

    flair_template.save! if flair_template.changed?

    return flair_template
  end
end