class DashboardsController < ApplicationController
  before_action -> { authorize_role!("admin") }, only: [:admin]
  before_action -> { authorize_role!("restaurant_owner") }, only: [:owner]
  before_action -> { authorize_role!("customer") }, only: [:customer]

  def admin
    # Admin overview logic (e.g., all users, stats)
  end

  def owner
    @restaurants = current_user.restaurants
  end

  def customer
    @restaurants = Restaurant.includes(:menu_items).order(created_at: :desc)
  end
end
