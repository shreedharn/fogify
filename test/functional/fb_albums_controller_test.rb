require 'test_helper'

class FbAlbumsControllerTest < ActionController::TestCase
  setup do
    @fb_album = fb_albums(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fb_albums)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fb_album" do
    assert_difference('FbAlbum.count') do
      post :create, fb_album: {  }
    end

    assert_redirected_to fb_album_path(assigns(:fb_album))
  end

  test "should show fb_album" do
    get :show, id: @fb_album
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fb_album
    assert_response :success
  end

  test "should update fb_album" do
    put :update, id: @fb_album, fb_album: {  }
    assert_redirected_to fb_album_path(assigns(:fb_album))
  end

  test "should destroy fb_album" do
    assert_difference('FbAlbum.count', -1) do
      delete :destroy, id: @fb_album
    end

    assert_redirected_to fb_albums_path
  end
end
