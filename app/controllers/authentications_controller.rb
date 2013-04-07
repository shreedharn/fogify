class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]

  def index
    # get all authentication services assigned to the current user
    @authentications = current_user.authentications.all
  end

  def create

#   render :text => request.env["omniauth.auth"].to_yaml

    params[:provider] ? auth_route = params[:provider] : auth_route = 'no authentication service (invalid callback)'
    omniauth = request.env['omniauth.auth']
    access_token = ''
    if omniauth and params[:provider]

      if auth_route == 'facebook'
        omniauth['extra']['raw_info']['email'] ? email = omniauth['extra']['raw_info']['email'] : email = ''
        omniauth['extra']['raw_info']['name'] ? name = omniauth['extra']['raw_info']['name'] : name = ''
        omniauth['extra']['raw_info']['id'] ? uid = omniauth['extra']['raw_info']['id'] : uid = ''
        omniauth['provider'] ? provider = omniauth['provider'] : provider = ''
        omniauth['credentials']['token'] ? access_token = omniauth['credentials']['token'] : access_token = ''
=begin  Block not supported
      elsif auth_route == 'google'
        omniauth['info']['email'] ? email = omniauth['info']['email'] : email = ""
        omniauth['info']['name'] ? name = omniauth['info']['name'] : name = ""
        omniauth['uid'] ? uid = omniauth['uid'] : uid = ''
        omniauth['provider'] ? provider = omniauth['provider'] : provider = ""
      end
=end
      else
        render :text => 'Authentication method not supported !'
        return;
      end

    else
        render :text => 'Error: Omniauth is empty'
        return;
    end
    # continue only if provider and uid exist
    if uid != '' and provider != ''

      # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
      if true

        # check if user has already signed in using this authentication provider and continue with sign in process if yes
        auth = Authentication.find_by_provider_and_uid(provider, uid)
        if auth
          flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
          @graph = Koala::Facebook::API.new(access_token)
          profile = @graph.get_object("me")
          friends = @graph.get_connections("me", "friends")
          sign_in_and_redirect(:user, auth.user)
        else
          # check if this user is already registered with this email address; get out if no email has been provided
          if email != ''
            # search for a user with this email address
            existinguser = User.find_by_email(email)
            @graph = Koala::Facebook::API.new(access_token)
            profile = @graph.get_object("me")
            if existinguser
              # map this new login method via a authentication provider to an existing account if the email address is the same
#             existinguser.authentications.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
              existinguser.authentications.access_token =  access_token
              existinguser.save!
              flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
              sign_in(:user, existinguser)
              redirect_to  :album => index
            else
              # let's create a new user: register this user and add this authentication method for this user
              name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us

              # new user, set email, a random password and take the name from the authentication service
              user = User.new :email => email, :password => SecureRandom.hex(10)

              # add this authentication service to our new user
              user.authentications.build(:provider => provider, :uid => uid, :uname => name, :uemail => email, :access_token => access_token)
              # do not send confirmation email, we directly save and confirm the new record
#             user.skip_confirmation!
              user.save!
#             user.confirm!


              # flash and sign in
              flash[:myinfo] = 'Your account with fogify has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
              sign_in(:user, user)
              redirect_to  :albums => index
            end
          else
            flash[:error] =  auth_route.capitalize + ' can not be used to sign-up on fogify as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + auth_route.capitalize + ' from your profile.'
            redirect_to new_user_session_path
          end
        end
      end
    end
  end
end
