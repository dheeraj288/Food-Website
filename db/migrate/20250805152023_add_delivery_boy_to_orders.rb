class AddDeliveryBoyToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :delivery_boy, null: false, foreign_key: true
    add_column :orders, :delivery_address, :string
    add_column :orders, :latitude, :float
    add_column :orders, :longitude, :float
  end
end
