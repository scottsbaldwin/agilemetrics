class Sprint < ActiveRecord::Base
	validates :sprint_name, :presence => true
	validates :end_date, :presence => true
	validates :code_coverage, :numericality => { :greater_than_or_equal_to => 0 }
	validates :nr_manual_tests, :numericality => { :greater_than_or_equal_to => 0 }
	validates :nr_automated_tests, :numericality => { :greater_than_or_equal_to => 0 }

	belongs_to :team
end
