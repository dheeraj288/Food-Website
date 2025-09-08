ActiveAdmin.register Review do
  permit_params :rating, :comment, :user_id, :restaurant_id

  menu parent: "⭐ Reviews", priority: 1

  index do
    selectable_column
    id_column
    column :user
    column :restaurant
    column :rating
    column :comment
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :restaurant
      row :rating
      row :comment
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Review Details" do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :restaurant, as: :select, collection: Restaurant.all.map { |r| [r.name, r.id] }
      f.input :rating
      f.input :comment
    end
    f.actions
  end
end
