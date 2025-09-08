ActiveAdmin.register Restaurant do
  permit_params :name, :description, :location, :image_url, :user_id,
                menu_items_attributes: [:id, :name, :description, :price, :dish_category_id, :_destroy]

  menu parent: "🍽 Restaurants", priority: 1

  index do
    selectable_column
    id_column
    column :name
    column :location
    column "Owner" do |r|
      r.user&.email
    end
    column "Menu Items" do |r|
      r.menu_items.count
    end
    column "Avg Rating" do |r|
      "#{r.average_rating} / 5"
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :location
      row :user
      row :image_url do |r|
        image_tag r.image_url, size: "200x120" if r.image_url.present?
      end
    end

    panel "Menu Items" do
      table_for restaurant.menu_items do
        column :name
        column :dish_category
        column :price
        column :description do |mi|
          mi.description.to_s.html_safe
        end
      end
    end

    panel "Reviews" do
      table_for restaurant.reviews do
        column :user
        column :rating
        column :comment
        column :created_at
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Restaurant Details" do
      f.input :name
      f.input :description
      f.input :location
      f.input :image_url, as: :file, hint: f.object.image_url.present? ? image_tag(f.object.image_url, size: "150x100") : "No image uploaded"
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
    end

    f.inputs "Menu Items" do
      f.has_many :menu_items, allow_destroy: true, new_record: "➕ Add Menu Item" do |mi|
        mi.input :name
        mi.input :description
        mi.input :price
        mi.input :dish_category, as: :select, collection: DishCategory.all.map { |dc| [dc.name, dc.id] }
      end
    end
    f.actions
  end
end
