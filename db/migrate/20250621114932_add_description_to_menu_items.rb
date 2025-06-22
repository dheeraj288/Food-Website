class AddDescriptionToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_column :menu_items, :description, :text
  end
end
