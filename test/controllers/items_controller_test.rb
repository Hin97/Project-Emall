require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get newtransaction" do
    get items_newtransaction_url
    assert_response :success
  end

end
