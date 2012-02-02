class Team < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	validates :sprint_weeks, :presence => true,
							:numericality => { :less_than => 3, :greater_than => 0 }

	has_many :sprints, 
					:order => "sprint_name asc, end_date asc", 
					:dependent => :destroy
end
