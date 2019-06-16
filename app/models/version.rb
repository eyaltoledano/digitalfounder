class Version < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  has_many :version_users
  has_many :users, through: :version_users
  has_many :tasks

  def slug
  	self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
  	self.all.find{ |instance| instance.slug == slug }
  end
end
