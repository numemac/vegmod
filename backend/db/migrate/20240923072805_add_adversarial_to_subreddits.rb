class AddAdversarialToSubreddits < ActiveRecord::Migration[7.1]
  def change
    add_column :subreddits, :adversarial, :boolean, default: false
  end
end
