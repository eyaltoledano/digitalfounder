class User < ActiveRecord::Base
  has_secure_password
  has_many :products
  belongs_to :version, required: false
end
