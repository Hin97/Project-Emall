require 'test_helper'

class CetegoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get cetegories_new_url
    assert_response :success
  end

  test "should get show" do
    get cetegories_show_url
    assert_response :success
  end

end
