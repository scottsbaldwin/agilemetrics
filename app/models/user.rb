class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :password, :password_confirmation, :remember_me, :remember_token, :first_name, :last_name, :email

  validates :login, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
end
