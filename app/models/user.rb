class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          has_many :email_otps, dependent: :destroy
          has_many :restaurants, dependent: :destroy
          has_many :reviews, dependent: :destroy
          has_one :cart, dependent: :destroy
          has_many :cart_items, through: :cart
          has_many :orders

          scope :owned_by, ->(user) { where(user_id: user.id) }

  enum role: { customer: "customer", restaurant_owner: "restaurant_owner", admin: "admin" }

  validates :role, presence: true

  after_create :create_cart

  private

  def create_cart
    Cart.create(user: self)
  end
end


