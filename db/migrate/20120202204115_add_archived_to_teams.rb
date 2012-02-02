class AddArchivedToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :is_archived, :boolean, :default => false

  end
end
