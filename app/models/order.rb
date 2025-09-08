class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant   
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy
   accepts_nested_attributes_for :order_items, allow_destroy: true
  belongs_to :delivery_boy, optional: true  # Add this


  enum status: {
  pending: "pending",
  confirmed: "confirmed",
  preparing: "preparing",
  out_for_delivery: "out_for_delivery",
  delivered: "delivered",
  cancelled: "cancelled"
}


  after_initialize :set_default_status, if: :new_record?

  validates :user, presence: true
  validates :restaurant, presence: true

  private

  def set_default_status
    self.status ||= "pending"
  end
end
