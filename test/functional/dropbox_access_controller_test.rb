require 'test_helper'

class DropboxAccessControllerTest < ActionController::TestCase
  test "should get authenticate" do
    get :authenticate
    assert_response :success
  end

  test "should get getauthtoken" do
    get :getauthtoken
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

end
