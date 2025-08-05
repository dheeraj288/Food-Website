# app/controllers/delivery_boys_controller.rb
class DeliveryBoysController < ApplicationController
  before_action :set_delivery_boy

  def update_location
    if @delivery_boy.update(latitude: params[:latitude], longitude: params[:longitude])
      render json: { success: true }
    else
      render json: { success: false, errors: @delivery_boy.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def set_delivery_boy
    @delivery_boy = DeliveryBoy.find(params[:id])
  end
end
