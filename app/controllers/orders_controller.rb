class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
                          .includes(order_items: :menu_item)
                          .order(created_at: :desc)
  end

  def show
    @order = current_user.orders
                         .includes(order_items: :menu_item)
                         .find(params[:id])
  end

  def create
    cart = current_user.cart
    if cart.blank? || cart.cart_items.blank?
      redirect_to cart_path, alert: "Your cart is empty!" and return
    end

    begin
      order = build_order_from_cart(cart)
      redirect_to order_path(order), notice: "Order placed successfully!"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to cart_path, alert: "Order failed: #{e.message}"
    end
  end

  private

  def build_order_from_cart(cart)
    ActiveRecord::Base.transaction do
      order = current_user.orders.create!(
        restaurant: cart.restaurant,
        total: calculate_total(cart),
        status: :pending
      )
      cart.cart_items.includes(:menu_item).each do |item|
        order.order_items.create!(
          menu_item: item.menu_item,
          quantity: item.quantity,
          price: item.menu_item.price
        )
      end
      order
    end
  end

  def calculate_total(cart)
    cart.cart_items.includes(:menu_item).sum do |item|
      item.menu_item.price * item.quantity
    end
  end
end
