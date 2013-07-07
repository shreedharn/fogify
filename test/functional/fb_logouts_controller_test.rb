require 'test_helper'

class FbLogoutsControllerTest < ActionController::TestCase
  setup do
    @fb_logout = fb_logouts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fb_logouts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fb_logout" do
    assert_difference('FbLogout.count') do
      post :create, fb_logout: {  }
    end

    assert_redirected_to fb_logout_path(assigns(:fb_logout))
  end

  test "should show fb_logout" do
    get :show, id: @fb_logout
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fb_logout
    assert_response :success
  end

  test "should update fb_logout" do
    put :update, id: @fb_logout, fb_logout: {  }
    assert_redirected_to fb_logout_path(assigns(:fb_logout))
  end

  test "should destroy fb_logout" do
    assert_difference('FbLogout.count', -1) do
      delete :destroy, id: @fb_logout
    end

    assert_redirected_to fb_logouts_path
  end
end
