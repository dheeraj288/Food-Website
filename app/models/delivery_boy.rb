class DeliveryBoy < ApplicationRecord
  has_many :orders   # Ek delivery boy ke multiple orders ho sakte hain

  scope :available, -> { where(available: true) } 

  validates :name, presence: true
  validates :phone, presence: true
end
