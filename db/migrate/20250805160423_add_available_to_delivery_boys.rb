class AddAvailableToDeliveryBoys < ActiveRecord::Migration[7.1]
  def change
    add_column :delivery_boys, :available, :boolean
  end
end
