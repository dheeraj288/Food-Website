class DishCategory < ApplicationRecord
  has_many :menu_items
  validates :name, presence: true, uniqueness: true
end
