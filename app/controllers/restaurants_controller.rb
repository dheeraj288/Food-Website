# app/controllers/restaurants_controller.rb
class RestaurantsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_restaurant_owner!
  before_action :set_restaurant, only: %i[edit update destroy]

  def index
    @restaurants = current_user.restaurants
    @categories = DishCategory.all
    @restaurants = Restaurant.filtered(params)
  end

  def new
    @restaurant = current_user.restaurants.build
  end

  def create
    @restaurant = current_user.restaurants.build(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path, notice: "Restaurant created successfully!"
    else
      render :new
    end
  end

  def edit; end

  def show
    @restaurant = Restaurant.find(params[:id])
    @menu_items = @restaurant.menu_items.includes(:dish_category)
    @review = Review.new
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to restaurants_path, notice: "Updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path, notice: "Deleted successfully!"
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurants.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :location, :image_url)
  end

  def authorize_restaurant_owner!
    redirect_to root_path, alert: "Access denied" unless restaurant_owner_user?
  end
end
