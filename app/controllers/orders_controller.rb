class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :track, :update]

  def index
    @orders = current_user.orders
                          .includes(order_items: :menu_item)
                          .order(created_at: :desc)
  end

  def show
    @delivery_boy = @order.delivery_boy
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

  def track
    @delivery_boy = @order.delivery_boy
  end

  def update
    @order = current_user.orders.find(params[:id])
    if @order.update(order_params)
      redirect_to order_path(@order), notice: "Order updated successfully."
    else
      flash.now[:alert] = "Failed to update order."
      render :show
    end
  end

  private

  def set_order
    @order = current_user.orders.includes(order_items: :menu_item).find(params[:id])
  end

  def order_params
    params.require(:order).permit(:delivery_address, :latitude, :longitude, :status, :delivery_boy_id)
  end

  def build_order_from_cart(cart)
    ActiveRecord::Base.transaction do
      delivery_boy = DeliveryBoy.available.first
      raise "No delivery boy available" unless delivery_boy

      order = current_user.orders.create!(
                restaurant: cart.restaurant,
                total: calculate_total(cart),
                status: :pending,
                delivery_address: params[:delivery_address],
                latitude: 28.6139,
                longitude: 77.2090,
                delivery_boy: delivery_boy
              )

      cart.cart_items.includes(:menu_item).each do |item|
        order.order_items.create!(
          menu_item: item.menu_item,
          quantity: item.quantity,
          price: item.menu_item.price
        )
      end

      cart.destroy # Clear cart after placing order
      order
    end
  end

  def calculate_total(cart)
    cart.cart_items.includes(:menu_item).sum do |item|
      item.menu_item.price * item.quantity
    end
  end
end
