require 'pycall'

class Praw::Subreddit

  def initialize(subreddit)
    @praw = PyCall.import_module('vegmod.pycall')
    @subreddit = subreddit
    @id = subreddit.display_name
  end

  def widgets_sidebar_delete_all
    Reddit::PrawLog.create!(action: "widgets_sidebar_delete_all", context: @subreddit)
    @praw.subreddit_widgets_sidebar_delete_all(@id)
  end

  # subreddit_widgets_sidebar_delete_widget(subreddit_id: str, id: str) -> Optional[Dict]:
  def widgets_sidebar_delete_widget(id)
    Reddit::PrawLog.create!(action: "widgets_sidebar_delete_widget", context: @subreddit)
    @praw.subreddit_widgets_sidebar_delete_widget(@id, id)
  end

  # def subreddit_widgets_mod_add_image_widget(subreddit_id: str, short_name: str, image_url: str, link_url: str) -> Optional[Dict]:
  def widgets_mod_add_image_widget(short_name, image_url, link_url)
    Reddit::PrawLog.create!(action: "widgets_mod_add_image_widget", context: @subreddit)
    @praw.subreddit_widgets_mod_add_image_widget(@id, short_name, image_url, link_url)
  end

  # def subreddit_widgets_mod_reupload_image(subreddit_id: str, widget_id: str, image_url: str, link_url: str) -> Optional[Dict]:
  def widgets_mod_reupload_image(widget_id, image_url, link_url)
    Reddit::PrawLog.create!(action: "widgets_mod_reupload_image", context: @subreddit)
    @praw.subreddit_widgets_mod_reupload_image(@id, widget_id, image_url, link_url)
  end
  

  # def subreddit_widgets_mod_add_community_list(subreddit_id: str, short_name: str, description: str, subreddits: List[str]) -> Optional[Dict]:
  # subreddits are a string array
  def widgets_mod_add_community_list(short_name, description, subreddits)
    Reddit::PrawLog.create!(action: "widgets_mod_add_community_list", context: @subreddit)
    @praw.subreddit_widgets_mod_add_community_list(@id, short_name, description, subreddits)
  end


  # def subreddit_widgets_mod_add_button_widget(subreddit_id: str, short_name: str, description: str, texts: List[str], urls: List[str]) -> Optional[Dict]:
  def widgets_mod_add_button_widget(short_name, description, texts, urls)
    Reddit::PrawLog.create!(action: "widgets_mod_add_button_widget", context: @subreddit)
    @praw.subreddit_widgets_mod_add_button_widget(@id, short_name, description, texts, urls)
  end

  # def subreddit_widgets_mod_add_text_area(subreddit_id: str, short_name: str, text: str) -> Optional[Dict]:
  def widgets_mod_add_text_area(short_name, text)
    Reddit::PrawLog.create!(action: "widgets_mod_add_text_area", context: @subreddit)
    @praw.subreddit_widgets_mod_add_text_area(@id, short_name, text)
  end

  # def subreddit_widgets_mod_update_text_area(subreddit_id: str, widget_id: str, short_name: str, text: str) -> Optional[Dict]:
  def widgets_mod_update_text_area(widget_id, short_name, text)
    Reddit::PrawLog.create!(action: "widgets_mod_update_text_area", context: @subreddit)
    @praw.subreddit_widgets_mod_update_text_area(@id, widget_id, short_name, text)
  end

  # def subreddit_widgets_mod_reorder(subreddit_id: str, widget_ids: List[str]) -> None:
  def widgets_mod_reorder(widget_ids)
    Reddit::PrawLog.create!(action: "widgets_mod_reorder", context: @subreddit)
    @praw.subreddit_widgets_mod_reorder(@id, widget_ids)
  end

end
