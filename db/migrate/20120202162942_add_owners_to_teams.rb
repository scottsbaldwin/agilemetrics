class AddOwnersToTeams < ActiveRecord::Migration
  def up
	add_column :teams, :owners, :string
	Team.update_all ["owners = ?", 'admin']
  end

  def down
	remove_column :teams, :owners
  end
end
