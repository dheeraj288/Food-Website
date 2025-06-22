class EmailOtp < ApplicationRecord
  belongs_to :user

  before_create :generate_otp

  def generate_otp
    self.otp_code = rand.to_s[2..7] # 6 digit OTP
    self.verified = false
    self.expires_at = 10.minutes.from_now
  end

  def expired?
    Time.current > expires_at
  end
end
