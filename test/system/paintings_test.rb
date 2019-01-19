require "application_system_test_case"

class PaintingsTest < ApplicationSystemTestCase
  setup do
    @painting = paintings(:one)
  end

  test "visiting the index" do
    visit paintings_url
    assert_selector "h1", text: "Paintings"
  end

  test "creating a Painting" do
    visit paintings_url
    click_on "New Painting"

    fill_in "Name", with: @painting.name
    fill_in "Price", with: @painting.price
    click_on "Create Painting"

    assert_text "Painting was successfully created"
    click_on "Back"
  end

  test "updating a Painting" do
    visit paintings_url
    click_on "Edit", match: :first

    fill_in "Name", with: @painting.name
    fill_in "Price", with: @painting.price
    click_on "Update Painting"

    assert_text "Painting was successfully updated"
    click_on "Back"
  end

  test "destroying a Painting" do
    visit paintings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Painting was successfully destroyed"
  end
end
