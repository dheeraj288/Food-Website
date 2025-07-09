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

    if cart.nil? || cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty!"
      return
    end

    if cart.restaurant.nil?
      redirect_to cart_path, alert: "Cart is not associated with any restaurant."
      return
    end

    begin
      order = nil
      ActiveRecord::Base.transaction do
        order = Order.create!(
          user: current_user,
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

        # cart.cart_items.destroy_all
      end

      redirect_to order_path(order), notice: "Order placed successfully!"
    rescue ActiveRecord::RecordInvalid => e
      logger.error "Order creation failed: #{e.record.errors.full_messages.join(', ')}"
      redirect_to cart_path, alert: "Order creation failed: #{e.record.errors.full_messages.to_sentence}"
    end
  end

  private

  def calculate_total(cart)
    cart.cart_items.includes(:menu_item).sum do |item|
      item.menu_item.price * item.quantity
    end
  end
end
