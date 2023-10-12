class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :registerable

  validates :login, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
end
