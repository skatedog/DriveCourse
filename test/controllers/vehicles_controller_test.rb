require 'test_helper'

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vehicles_new_url
    assert_response :success
  end

  test "should get edit" do
    get vehicles_edit_url
    assert_response :success
  end

end
