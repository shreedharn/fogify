require 'openid/store/filesystem'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
	   :scope => 'email,user_birthday,user_photos,read_stream, read_friendlists'

# provider :openid, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'

  #OpenId is now completely option driven
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google',
           :identifier => 'https://www.google.com/accounts/o8/id'
end