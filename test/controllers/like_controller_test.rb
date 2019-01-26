require 'test_helper'

class LikeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get like_create_url
    assert_response :success
  end

  test "should get destroy" do
    get like_destroy_url
    assert_response :success
  end

end
