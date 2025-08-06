class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = Cart.find_or_create_by(user_id: current_user.id)
    @cart_items = @cart.cart_items.includes(:menu_item)
  end
end
