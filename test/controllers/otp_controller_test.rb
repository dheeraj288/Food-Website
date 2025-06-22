require "test_helper"

class OtpControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get otp_new_url
    assert_response :success
  end

  test "should get verify" do
    get otp_verify_url
    assert_response :success
  end
end
