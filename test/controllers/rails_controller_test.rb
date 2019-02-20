require 'test_helper'

class RailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rail = rails(:one)
  end

  test "should get index" do
    get rails_url
    assert_response :success
  end

  test "should get new" do
    get new_rail_url
    assert_response :success
  end

  test "should create rail" do
    assert_difference('Rail.count') do
      post rails_url, params: { rail: { Notice: @rail.Notice, content: @rail.content, g: @rail.g, scaffold: @rail.scaffold, title: @rail.title } }
    end

    assert_redirected_to rail_url(Rail.last)
  end

  test "should show rail" do
    get rail_url(@rail)
    assert_response :success
  end

  test "should get edit" do
    get edit_rail_url(@rail)
    assert_response :success
  end

  test "should update rail" do
    patch rail_url(@rail), params: { rail: { Notice: @rail.Notice, content: @rail.content, g: @rail.g, scaffold: @rail.scaffold, title: @rail.title } }
    assert_redirected_to rail_url(@rail)
  end

  test "should destroy rail" do
    assert_difference('Rail.count', -1) do
      delete rail_url(@rail)
    end

    assert_redirected_to rails_url
  end
end
