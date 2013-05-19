require 'dropbox_sdk'
class DropboxAccessController < ApplicationController
  def index
    if not params[:oauth_token] then
      dbsession = DropboxSession.new(ENV['DROPBOX_APP_ID'], ENV['DROPBOX_SECRET'])

      session[:dropbox_session] = dbsession.serialize #serialize and save this DropboxSession

      #pass to get_authorize_url a callback url that will return the user here
      callback_url = url_for(:action => 'index')
      redirect_to dbsession.get_authorize_url callback_url
    else
      # the user has returned from Dropbox
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      access_token = dbsession.get_access_token  #we've been authorized, so now request an access_token
      session[:dropbox_session] = dbsession.serialize

      render :text => "successfully authenticated with dropbox"
    end
  end

  def getauthtoken
  end

  def create
    render :text => "Inside dropbox access create"
  end
end
