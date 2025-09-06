class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          has_many :email_otps, dependent: :destroy
          has_many :restaurants, dependent: :destroy
          has_many :reviews, dependent: :destroy
          has_one :cart, dependent: :destroy
          has_many :cart_items, through: :cart
          has_many :orders
          has_many :payments, dependent: :nullify


          scope :owned_by, ->(user) { where(user_id: user.id) }

  enum role: { customer: "customer", restaurant_owner: "restaurant_owner", admin: "admin" }

  validates :role, presence: true

  after_create :create_cart
   def self.ransackable_associations(auth_object = nil)
    ["cart", "cart_items", "email_otps", "orders", "payments", "restaurants", "reviews"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at"]
  end

  private

  def create_cart
    Cart.create(user: self)
  end
end


