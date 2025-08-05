class CreateDeliveryBoys < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_boys do |t|
      t.string :name
      t.string :phone
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
