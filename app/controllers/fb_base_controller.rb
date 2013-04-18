class FbBaseController < ApplicationController
  def get_fb_info()
    user_auth = current_user.authentications
    this_auth = user_auth.where("uemail = :uemail AND provider = :provider",
                                {:provider => 'facebook', :uemail => current_user.email}).first
    return nil, nil if this_auth.nil?
    return this_auth.uid, this_auth.access_token
  end
end
