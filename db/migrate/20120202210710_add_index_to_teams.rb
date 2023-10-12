class AddIndexToTeams < ActiveRecord::Migration
  def up
	add_index :teams, :name, :unique => true
  end

  def down
	remove_index :teams, :name
  end
end
