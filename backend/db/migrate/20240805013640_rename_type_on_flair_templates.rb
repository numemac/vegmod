class RenameTypeOnFlairTemplates < ActiveRecord::Migration[7.1]
  def change
    rename_column :flair_templates, :type, :external_type
  end
end
