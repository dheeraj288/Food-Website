class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    cart = current_user.cart
    item = cart.cart_items.find_by(menu_item_id: params[:menu_item_id])

    if item
      item.increment!(:quantity)
    else
      cart.cart_items.create!(menu_item_id: params[:menu_item_id], quantity: 1)
    end

    redirect_to cart_path, notice: "Item added to cart."
  end

  def update
    @cart_item = current_user.cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_path, notice: "Cart item updated successfully."
    else
      redirect_to cart_path, alert: "Failed to update item."
    end
  end

  def destroy
    item = current_user.cart.cart_items.find(params[:id])
    item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
