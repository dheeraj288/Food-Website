ActiveAdmin.register DishCategory do
  permit_params :name

  menu parent: "🍽 Restaurants", priority: 3

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Menu Items in this Category" do
      table_for dish_category.menu_items do
        column :name
        column :restaurant
        column :price
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Dish Category Details" do
      f.input :name
    end
    f.actions
  end
end
