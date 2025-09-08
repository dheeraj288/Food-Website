ActiveAdmin.register Order do
  permit_params :user_id, :restaurant_id, :status, :delivery_boy_id,
                order_items_attributes: [:id, :menu_item_id, :quantity, :_destroy]

  menu parent: "📦 Orders", priority: 1

  # 📋 Index Page
  index do
    selectable_column
    id_column
    column :user
    column :restaurant
    column "Items Count" do |order|
      order.order_items.count
    end
    column :status do |order|
      status_tag order.status
    end
    column :delivery_boy
    column :created_at
    actions
  end

  # 👁 Show Page
  show do
    attributes_table do
      row :user
      row :restaurant
      row :status
      row :delivery_boy
      row :created_at
      row :updated_at
    end

    panel "Order Items" do
      table_for resource.order_items do
        column :menu_item
        column :quantity
        column "Price" do |oi|
          number_to_currency(oi.menu_item.price)
        end
        column "Subtotal" do |oi|
          number_to_currency(oi.menu_item.price * oi.quantity)
        end
      end
    end

    panel "Total Amount" do
      total = resource.order_items.map { |oi| oi.menu_item.price * oi.quantity }.sum
      h3 number_to_currency(total)
    end
  end

    form do |f|
      f.semantic_errors

      f.inputs "Order Details" do
        f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
        f.input :restaurant, as: :select, collection: Restaurant.all.map { |r| [r.name, r.id] }
        f.input :status, as: :select, collection: Order.statuses.keys
        f.input :delivery_boy, as: :select, collection: DeliveryBoy.all.map { |db| [db.name, db.id] }, include_blank: true
      end

      menu_item_options = MenuItem.all.map do |mi|
        ["#{mi.name} (₹#{mi.price})", mi.id]
      end

      f.inputs "Order Items" do
        f.has_many :order_items, allow_destroy: true, new_record: "➕ Add Order Item" do |oi|
          oi.input :menu_item, as: :select, collection: menu_item_options
          oi.input :quantity
        end
      end

      f.actions
    end
  end