class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_restaurant

  def create
    @review = @restaurant.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @restaurant, notice: "✅ Review added!"
    else
      flash.now[:alert] = "❌ Could not submit review."
      render "restaurants/show", status: :unprocessable_entity
    end
  end

  def destroy
    review = @restaurant.reviews.find(params[:id])
    if review.user == current_user || current_user.admin?
      review.destroy
      redirect_to @restaurant, notice: "Review deleted."
    else
      redirect_to @restaurant, alert: "Not authorized."
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
