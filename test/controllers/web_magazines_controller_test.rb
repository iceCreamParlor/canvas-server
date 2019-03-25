require 'test_helper'

class WebMagazinesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get web_magazines_index_url
    assert_response :success
  end

  test "should get show" do
    get web_magazines_show_url
    assert_response :success
  end

end
