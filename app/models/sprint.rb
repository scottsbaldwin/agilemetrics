class Sprint < ActiveRecord::Base
	validates :sprint_name, :presence => true
	validates :end_date, :presence => true

	belongs_to :team
end
