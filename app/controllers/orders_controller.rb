# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.includes(:restaurant, :order_items)
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    cart = current_user.cart
    order = current_user.orders.create!(restaurant: cart.restaurant, total: 0)

    cart.cart_items.each do |item|
      order.order_items.create!(
        menu_item: item.menu_item,
        quantity: item.quantity,
        price: item.menu_item.price
      )
    end

    order.update(total: order.order_items.sum("price * quantity"))
    cart.cart_items.destroy_all
    redirect_to order_path(order), notice: "Order placed successfully!"
  end
end
