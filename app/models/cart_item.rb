class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :menu_item
  belongs_to :restaurant, required: true


  validates :restaurant_id, presence: true

  validates :quantity, numericality: { greater_than: 0 }
  def subtotal
    menu_item.price * quantity
  end
end
