module Customers
  class RestaurantsController < ApplicationController
    before_action :authenticate_user!
    def index
      @restaurants = Restaurant.includes(:menu_items).order(created_at: :desc)
    end

    def show
      @restaurant = Restaurant.find(params[:id])
      @menu_items = @restaurant.menu_items.includes(:dish_category)
    end
  end
end
