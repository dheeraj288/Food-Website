class AddDishCategoryToMenuItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :menu_items, :dish_category, foreign_key: true
  end
end
