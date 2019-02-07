require 'test_helper'

class AuctionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get auction_index_url
    assert_response :success
  end

  test "should get new" do
    get auction_new_url
    assert_response :success
  end

  test "should get create" do
    get auction_create_url
    assert_response :success
  end

  test "should get edit" do
    get auction_edit_url
    assert_response :success
  end

  test "should get update" do
    get auction_update_url
    assert_response :success
  end

  test "should get destroy" do
    get auction_destroy_url
    assert_response :success
  end

end
