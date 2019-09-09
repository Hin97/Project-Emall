require 'test_helper'

class TradeControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get trade_new_url
    assert_response :success
  end

  test "should get create" do
    get trade_create_url
    assert_response :success
  end

end
