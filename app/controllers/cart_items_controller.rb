class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @menu_item = MenuItem.find(params[:menu_item_id])
    @cart = current_user.cart || current_user.create_cart!(restaurant: @menu_item.restaurant)

    @cart_item = @cart.cart_items.build(
      menu_item: @menu_item,
      quantity: 1,
      restaurant: @menu_item.restaurant
    )

    if @cart_item.save
      redirect_to cart_path, notice: 'Item added to cart.'
    else
      redirect_to cart_path, alert: @cart_item.errors.full_messages.join(", ")
    end
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
