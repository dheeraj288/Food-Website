ActiveAdmin.register User do
  permit_params :email, :role, :password, :password_confirmation

  menu parent: "👥 users", priority: 1

  index do
    selectable_column
    id_column
    column :email
    column :role
    column "Cart Total" do |user|
      number_to_currency(user.cart&.total_price || 0)
    end
    column "Orders Count" do |user|
      user.orders.count
    end
    column :created_at
    actions
  end

  filter :email
  filter :role
  filter :created_at

  show do
    attributes_table do
      row :email
      row :role
      row :created_at
      row :updated_at
    end

    panel "User Cart" do
      if user.cart.present?
        table_for user.cart.cart_items do
          column :menu_item
          column :quantity
          column "Price" do |ci|
            number_to_currency(ci.menu_item.price)
          end
          column "Subtotal" do |ci|
            number_to_currency(ci.subtotal)
          end
        end
      else
        div "No cart available"
      end
    end

    panel "Orders" do
      table_for user.orders do
        column :id
        column :restaurant
        column :status
        column "Items Count" do |order|
          order.order_items.count
        end
        column :created_at
      end
    end

    panel "Reviews" do
      table_for user.reviews do
        column :restaurant
        column :rating
        column :comment
        column :created_at
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "User Details" do
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
