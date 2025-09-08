ActiveAdmin.register Payment do
  permit_params :user_id, :order_id, :stripe_payment_intent_id, :amount, :status

  menu parent: "📦 Orders", priority: 2

  index do
    selectable_column
    id_column
    column :user
    column :order
    column :amount do |payment|
      number_to_currency(payment.amount)
    end
    column :status
    column :stripe_payment_intent_id
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :order
      row :amount do |payment|
        number_to_currency(payment.amount)
      end
      row :status
      row :stripe_payment_intent_id
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Payment Details" do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :order, as: :select, collection: Order.all.map { |o| ["Order ##{o.id} (#{o.user.email})", o.id] }
      f.input :amount
      f.input :status, as: :select, collection: ["pending", "paid", "failed"]
      f.input :stripe_payment_intent_id
    end
    f.actions
  end
end
