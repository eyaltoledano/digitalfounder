class Version < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  has_many :contributors, :class_name => 'User', :foreign_key => 'user_id'
end
