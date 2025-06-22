class UserMailer < ApplicationMailer
  def send_otp(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: "Your OTP Code")
  end
end
