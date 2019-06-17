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

  def open_tasks
    self.tasks.where(status: "Open")
  end

  def tasks_with_contributors
    self.tasks.where(user_id: !nil)
  end

  def total_awarded
    rewarded = []
    @version.tasks.where(status: "Complete").each do |task|
      rewarded << task.reward.to_f
    end
    total_awarded = rewarded.inject(0){|sum,x| sum + x }
  end

  def unique_contributors
    contributors = []
    self.tasks_with_contributors.each do |task|
      contributors << task.user_id
    end
    contributors = contributors.collect do |c|
      c = User.find(c)
    end
    contributors.uniq
  end
end
