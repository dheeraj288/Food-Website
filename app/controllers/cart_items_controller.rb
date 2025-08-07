class CartItemsController < ApplicationController
  before_action :authenticate_user!

   def create
    @menu_item = MenuItem.find(params[:menu_item_id])
    @cart = current_user.cart || current_user.create_cart!(restaurant: @menu_item.restaurant)

    @cart_item = @cart.cart_items.find_or_initialize_by(menu_item: @menu_item)
    @cart_item.quantity ||= 0
    @cart_item.quantity += 1
    @cart_item.restaurant = @menu_item.restaurant

    respond_to do |format|
      if @cart_item.save
        format.html { redirect_to cart_path, notice: 'Item added to cart.' }
        format.json { render json: { success: true, cart_item_count: @cart.cart_items.sum(:quantity) } }
      else
        format.html { redirect_to cart_path, alert: @cart_item.errors.full_messages.join(", ") }
        format.json { render json: { success: false, errors: @cart_item.errors.full_messages } }
      end
    end
  end

  def update
    @cart_item = current_user.cart.cart_items.find(params[:id])
    new_quantity = cart_item_params[:quantity].to_i

    if new_quantity <= 0
      @cart_item.destroy
      redirect_to cart_path, notice: "Item removed from cart."
    elsif @cart_item.update(quantity: new_quantity)
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
