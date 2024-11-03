class DenySubredditPluginsConfigBeNull < ActiveRecord::Migration[7.1]
  def change
    change_column :subreddit_plugins, :config, :jsonb, null: false
  end
end
