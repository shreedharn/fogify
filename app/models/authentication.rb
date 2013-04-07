class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uemail, :uid, :uname, :user_id, :access_token

  def get_access
    :access_token
  end
end
