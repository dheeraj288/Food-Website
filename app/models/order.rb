class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant      # Added association
  has_many :order_items, dependent: :destroy
  has_many :payments, dependent: :destroy

  enum status: { pending: "pending", confirmed: "confirmed", delivered: "delivered" }

  after_initialize :set_default_status, if: :new_record?

  validates :user, presence: true
  validates :restaurant, presence: true

  private

  def set_default_status
    self.status ||= "pending"
  end
end
