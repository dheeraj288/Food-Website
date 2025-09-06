ActiveAdmin.register Restaurant do
  permit_params :name, :description, :location, :image_url, :user_id,
                menu_items_attributes: [:id, :name, :description, :price, :dish_category_id, :_destroy]

 index do
  selectable_column
    id_column
    column "Image" do |restaurant|
      if restaurant.image_url.present?
        image_tag restaurant.image_url, size: "80x50"
      else
        status_tag "No Image", :warning
      end
    end
    column :name
    column :location
    column "Owner" do |restaurant|
      restaurant.user&.email
    end
    column "Menu Items" do |restaurant|
      restaurant.menu_items.count
    end
    column "Avg Rating" do |restaurant|
      "#{restaurant.average_rating} / 5"
    end
    column :created_at do |restaurant|
      restaurant.created_at.strftime("%d %b %Y %I:%M %p")
    end
    actions 
end


  form do |f|
    f.semantic_errors

    f.inputs "Restaurant Details" do
      f.input :name
      f.input :description
      f.input :location
      f.input :image_url, as: :file,
              hint: f.object.image_url.present? ? image_tag(f.object.image_url, size: "150x100") : "No image uploaded"
      f.input :user, label: "Owner", as: :select, collection: User.all.map { |u| [u.email, u.id] }
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

   show do
    attributes_table do
      row :name
      row :description
      row :location
      row :user
      row :image_url do |restaurant|
        if restaurant.image_url.present?
          image_tag restaurant.image_url, size: "200x120"
        else
          status_tag "No Image", :warning
        end
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
        column "Image" do |mi|
          if mi.image_url.present?
            image_tag mi.image_url, size: "120x80"
          else
            status_tag "No Image", :warning
          end
        end
      end
    end
  end
end
