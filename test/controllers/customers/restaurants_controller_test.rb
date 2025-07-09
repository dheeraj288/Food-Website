require "test_helper"

class Customers::RestaurantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customers_restaurants_index_url
    assert_response :success
  end

  test "should get show" do
    get customers_restaurants_show_url
    assert_response :success
  end
end
