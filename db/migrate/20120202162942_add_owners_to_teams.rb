class AddOwnersToTeams < ActiveRecord::Migration
  def up
	add_column :teams, :owners, :string
	Team.update_all ["owners = ?", 'jesser, sbaldwin']
  end

  def down
	remove_column :teams, :owners
  end
end
