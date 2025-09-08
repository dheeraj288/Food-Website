ActiveAdmin.register CartItem do
  permit_params :cart_id, :menu_item_id, :quantity, :restaurant_id

  menu parent: "🛒 Carts", priority: 2

  index do
    selectable_column
    id_column
    column :cart
    column :menu_item
    column :quantity
    column "Price" do |ci|
      number_to_currency(ci.menu_item.price)
    end
    column "Subtotal" do |ci|
      number_to_currency(ci.quantity * ci.menu_item.price)
    end
    actions
  end

  show do
    attributes_table do
      row :cart
      row :menu_item
      row :quantity
      row "Price" do |ci|
        number_to_currency(ci.menu_item.price)
      end
      row "Subtotal" do |ci|
        number_to_currency(ci.quantity * ci.menu_item.price)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Cart Item Details" do
      f.input :cart, as: :select, collection: Cart.all.map { |c| ["Cart ##{c.id} (#{c.user.email})", c.id] }
      f.input :menu_item, as: :select, collection: MenuItem.all.map { |mi| ["#{mi.name} (₹#{mi.price})", mi.id] }
      f.input :quantity
      f.input :restaurant, as: :select, collection: Restaurant.all.map { |r| [r.name, r.id] }
    end
    f.actions
  end
end
