ActiveAdmin.register DeliveryBoy do
  permit_params :name, :phone, :available

  menu parent: "📦 Orders", priority: 3

  index do
    selectable_column
    id_column
    column :name
    column :phone
    column :available
    column :created_at
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Delivery Boy Details" do
      f.input :name
      f.input :phone
      f.input :available
    end
    f.actions
  end
end
