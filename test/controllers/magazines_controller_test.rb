require 'test_helper'

class MagazinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @magazine = magazines(:one)
  end

  test "should get index" do
    get magazines_url
    assert_response :success
  end

  test "should get new" do
    get new_magazine_url
    assert_response :success
  end

  test "should create magazine" do
    assert_difference('Magazine.count') do
      post magazines_url, params: { magazine: {  } }
    end

    assert_redirected_to magazine_url(Magazine.last)
  end

  test "should show magazine" do
    get magazine_url(@magazine)
    assert_response :success
  end

  test "should get edit" do
    get edit_magazine_url(@magazine)
    assert_response :success
  end

  test "should update magazine" do
    patch magazine_url(@magazine), params: { magazine: {  } }
    assert_redirected_to magazine_url(@magazine)
  end

  test "should destroy magazine" do
    assert_difference('Magazine.count', -1) do
      delete magazine_url(@magazine)
    end

    assert_redirected_to magazines_url
  end
end
