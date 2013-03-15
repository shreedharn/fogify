class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

		 
  has_many :authentications, :dependent => :destroy
  # Setup accessible (or protected) attributes for your model
  attr_accessible :fullname, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  def get_email
    :email
  end


end
