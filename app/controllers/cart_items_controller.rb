# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  before_action :prevent_owner_addition, only: [:create]

  def create
    cart = current_user.cart || current_user.create_cart(restaurant_id: params[:restaurant_id])
    item = cart.cart_items.find_or_initialize_by(menu_item_id: params[:menu_item_id])
    item.quantity = params[:quantity] || item.quantity + 1
    item.save
    redirect_to cart_path
  end

  def update
    item = CartItem.find(params[:id])
    item.update(quantity: params[:quantity])
    redirect_to cart_path
  end

  def destroy
    item = CartItem.find(params[:id])
    item.destroy
    redirect_to cart_path
  end
  
  private
  
  def prevent_owner_addition
    if current_user == MenuItem.find(params[:menu_item_id]).restaurant.user
      redirect_to root_path, alert: "Restaurant owners can't order their own items."
    end
  end
end


