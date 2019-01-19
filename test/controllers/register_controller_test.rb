require 'test_helper'

class RegisterControllerTest < ActionDispatch::IntegrationTest
  test "should get info1" do
    get register_info1_url
    assert_response :success
  end

  test "should get info2" do
    get register_info2_url
    assert_response :success
  end

end
