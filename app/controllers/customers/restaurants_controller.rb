module Customers
  class RestaurantsController < ApplicationController
    before_action :authenticate_user!
    
    def index
      @restaurants = current_user.restaurants
      @categories = DishCategory.all
      @restaurants = Restaurant.filtered(params)
    end


    def show
      @restaurant = Restaurant.find(params[:id])
      @menu_items = @restaurant.menu_items.includes(:dish_category)
    end
  end
end
