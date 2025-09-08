ActiveAdmin.register Cart do
  permit_params :user_id,
                cart_items_attributes: [:id, :menu_item_id, :quantity, :restaurant_id, :_destroy]

  menu parent: "🛒 Carts", priority: 1

  index do
    selectable_column
    id_column
    column :user
    column "Items Count" do |cart|
      cart.cart_items.count
    end
    column "Total Price" do |cart|
      number_to_currency(cart.total_price)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row "Total Price" do |cart|
        number_to_currency(cart.total_price)
      end
      row :created_at
    end

    panel "Cart Items" do
      table_for cart.cart_items do
        column :menu_item
        column :quantity
        column "Price" do |ci|
          number_to_currency(ci.menu_item.price)
        end
        column "Subtotal" do |ci|
          number_to_currency(ci.quantity * ci.menu_item.price)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Cart Details" do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
    end

    f.inputs "Cart Items" do
      f.has_many :cart_items, allow_destroy: true, new_record: "➕ Add Cart Item" do |ci|
        ci.input :menu_item, as: :select, collection: MenuItem.all.map { |mi| ["#{mi.name} (₹#{mi.price})", mi.id] }
        ci.input :quantity
        ci.input :restaurant, as: :select, collection: Restaurant.all.map { |r| [r.name, r.id] }
      end
    end

    f.actions
  end
end
