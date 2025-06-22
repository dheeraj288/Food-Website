class OtpController < ApplicationController
  skip_before_action :check_otp_verified!, only: [:new, :verify, :resend]
  skip_before_action :authenticate_user!, only: [:new, :verify, :resend]

  def new
    @user = User.find(params[:user_id])
    @context = params[:context]
  end

  def verify
    @user = User.find(params[:user_id])
    otp = @user.email_otps.order(created_at: :desc).first

    if otp.present? && otp.otp_code == params[:otp_code] && !otp.expired?
      otp.update(verified: true)
      sign_in(@user) unless user_signed_in?
      redirect_to after_sign_in_path_for(@user), notice: "OTP verified successfully!"
    else
      flash[:alert] = "Invalid or expired OTP."
      redirect_to otp_verification_path(user_id: @user.id, context: params[:context])
    end
  end

  def resend
    @user = User.find(params[:user_id])
    @context = params[:context]

    last_otp = @user.email_otps.order(created_at: :desc).first

    if last_otp && last_otp.created_at > 30.seconds.ago
      flash[:alert] = "Please wait before requesting another OTP."
    else
      new_otp = @user.email_otps.create!(
        otp_code: rand(100000..999999),
        expires_at: 10.minutes.from_now
      )
      UserMailer.send_otp(@user, new_otp).deliver_later
      flash[:notice] = "New OTP sent to your email."
    end

    redirect_to otp_verification_path(user_id: @user.id, context: @context)
  end
end
