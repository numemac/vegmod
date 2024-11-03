class AddFieldsToSubreddit < ActiveRecord::Migration[7.1]
  def change
    # allow_discovery: bool
    # banner_background_image: str
    # community_icon: str
    # hide_ads: bool
    # public_traffic: bool
    # title: str
    # wls: int

    add_column :subreddits, :allow_discovery, :boolean
    add_column :subreddits, :banner_background_image, :string
    add_column :subreddits, :community_icon, :string
    add_column :subreddits, :hide_ads, :boolean
    add_column :subreddits, :public_traffic, :boolean
    add_column :subreddits, :title, :string
    add_column :subreddits, :wls, :integer
  end
end
