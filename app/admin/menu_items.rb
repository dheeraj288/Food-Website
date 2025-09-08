ActiveAdmin.register MenuItem do
  permit_params :name, :price, :restaurant_id, :description, :image_url, :dish_category_id

  menu parent: "🍽 Restaurants", priority: 2

  index do
    selectable_column
    id_column
    column "Image" do |menu_item|
      if menu_item.image_url.present?
        image_tag menu_item.image_url, size: "80x50"
      else
        status_tag "No Image", :warning
      end
    end
    column :name
    column :dish_category
    column :restaurant
    column :price
    column :created_at
    actions
  end

  filter :name
  filter :dish_category
  filter :restaurant
  filter :price
  filter :created_at

  show do
    attributes_table do
      row :name
      row :dish_category
      row :restaurant
      row :price
      row :description do |mi|
        mi.description.to_s.html_safe
      end
      row :image_url do |mi|
        image_tag mi.image_url, size: "200x120" if mi.image_url.present?
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Menu Item Details" do
      f.input :name
      f.input :price
      f.input :dish_category, as: :select, collection: DishCategory.all.map { |dc| [dc.name, dc.id] }
      f.input :restaurant, as: :select, collection: Restaurant.all.map { |r| [r.name, r.id] }
      f.input :description
      f.input :image_url, as: :file,
              hint: f.object.image_url.present? ? image_tag(f.object.image_url, size: "100x80") : "No image uploaded"
    end
    f.actions
  end
end
