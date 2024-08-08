class AddSubredditToReports < ActiveRecord::Migration[7.1]
  def change
    # add index unique to polymorphic content
    add_index :reports, [:content_type, :content_id], unique: true
  end
end
