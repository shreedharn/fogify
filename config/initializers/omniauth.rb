require 'openid/store/filesystem'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'],
	   :scope => 'user_birthday, friends_birthday, user_photos, friends_photos, user_status, friends_status, read_stream'


# provider :openid, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'openid'

  #OpenId is now completely option driven
  provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google',
           :identifier => 'https://www.google.com/accounts/o8/id'
end