class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :check_otp_verified!

  helper_method :admin_user?, :restaurant_owner_user?, :customer_user?

  ROLES = %w[admin restaurant_owner customer].freeze

  def authorize_role!(required_role)
    unless current_user&.role == required_role
      redirect_to root_path, alert: "Access denied"
    end
  end

  def check_otp_verified!
    return unless user_signed_in?

    last_otp = current_user.email_otps.order(created_at: :desc).first
    return if last_otp&.verified?
    return if request.path.start_with?("/otp_verification") || request.path.start_with?("/resend_otp")

    redirect_to otp_verification_path(user_id: current_user.id, context: "login"), alert: "Please verify your email via OTP."
  end

  def after_sign_in_path_for(resource)
    case resource.role
    when "admin"
      admin_dashboard_path
    when "restaurant_owner"
      owner_dashboard_path
    else
      customer_dashboard_path
    end
  end

  def admin_user?
    user_signed_in? && current_user.role == "admin"
  end

  def restaurant_owner_user?
    user_signed_in? && current_user.role == "restaurant_owner"
  end

  def customer_user?
    user_signed_in? && current_user.role == "customer"
  end
end
