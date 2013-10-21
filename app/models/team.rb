class Team < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	validates :sprint_weeks, :presence => true,
				:numericality => { :less_than => 3, :greater_than => 0 }
	validates :test_certification, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5, :only_integer => true }

	has_many :sprints, -> { order("sprint_name asc, end_date asc") }, :dependent => :destroy

	has_one :trello_account, dependent: :destroy
	accepts_nested_attributes_for :trello_account, reject_if: lambda { |attrs| attrs[:public_key].empty? && attrs[:read_token].empty? && attrs[:board_id].empty? && attrs[:list_name_for_backlog].empty? }
end
