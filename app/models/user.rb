class User < ActiveRecord::Base
  has_secure_password
  has_many :products
  has_many :version_users
  has_many :versions, through: :version_users

  def slug
  	self.username.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
  	self.all.find{ |instance| instance.slug == slug }
  end
end
