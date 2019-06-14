class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :version
end
