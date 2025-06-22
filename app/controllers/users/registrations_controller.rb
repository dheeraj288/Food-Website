class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      otp = resource.email_otps.create
      UserMailer.send_otp(resource, otp).deliver_now
      redirect_to otp_verification_path(user_id: resource.id)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end
end
