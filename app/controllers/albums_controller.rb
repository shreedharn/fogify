class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  before_filter :authenticate_user!

  def index
    user_auth = current_user.authentications
    this_auth =  user_auth.where(:uemail => current_user.email).first

    @graph = Koala::Facebook::API.new(this_auth.access_token);
    profile = @graph.get_object("me")
    render :text => profile.to_s
  end

end
