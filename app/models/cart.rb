class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :cart_items, dependent: :destroy

   def total_price
    cart_items.includes(:menu_item).sum { |ci| ci.menu_item.price * ci.quantity }
  end
end
