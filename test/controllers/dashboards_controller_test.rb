require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get admin" do
    get dashboards_admin_url
    assert_response :success
  end

  test "should get owner" do
    get dashboards_owner_url
    assert_response :success
  end

  test "should get customer" do
    get dashboards_customer_url
    assert_response :success
  end
end
