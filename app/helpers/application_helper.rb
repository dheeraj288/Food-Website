module ApplicationHelper
  def admin_user?
    user_signed_in? && current_user.admin?
  end

  def restaurant_owner_user?
    user_signed_in? && current_user.restaurant_owner?
  end

  def customer_user?
    user_signed_in? && current_user.customer?
  end
end
