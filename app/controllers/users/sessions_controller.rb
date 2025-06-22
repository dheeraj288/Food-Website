class Users::SessionsController < Devise::SessionsController
  def create
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      otp = user.email_otps.create
      UserMailer.send_otp(user, otp).deliver_now
      redirect_to otp_verification_path(user_id: user.id, context: "login")
    else
      flash[:alert] = "Invalid Email or Password"
      redirect_to new_user_session_path
    end
  end
end
