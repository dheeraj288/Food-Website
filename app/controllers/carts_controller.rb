# app/controllers/carts_controller.rb
class CartsController < ApplicationController
  before_action :set_cart

  def show
    @cart_items = @cart.cart_items.includes(:menu_item)
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart(restaurant_id: params[:restaurant_id])
  end
end
