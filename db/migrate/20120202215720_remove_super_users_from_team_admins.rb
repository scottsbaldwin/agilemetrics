class RemoveSuperUsersFromTeamAdmins < ActiveRecord::Migration
  def up
	Team.all.each do |team|
		team.update_attribute :owners, team.owners.sub(/(, )*jesser, sbaldwin/, "") if team.owners != nil
	end
  end
end
