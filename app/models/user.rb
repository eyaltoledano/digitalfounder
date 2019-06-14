class User < ActiveRecord::Base
  has_secure_password
  has_many :products
  has_many :version_users
  has_many :versions, through: :version_users
end
