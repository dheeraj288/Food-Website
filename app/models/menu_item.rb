class MenuItem < ApplicationRecord
  belongs_to :restaurant
  has_rich_text :description
  belongs_to :dish_category
  validates :name, :price, presence: true
  validates :name, :price, :dish_category_id, presence: true
end
