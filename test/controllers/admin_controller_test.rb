require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    log_in_as(users(:michael))
    get admin_index_url
    assert_response :success
  end
end
