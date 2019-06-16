class Product < ActiveRecord::Base
  belongs_to :user
  has_many :versions

  def slug
  	self.name.gsub(" ", "-").downcase
  end

  def self.find_by_slug(slug)
  	self.all.find{ |instance| instance.slug == slug }
  end
end
