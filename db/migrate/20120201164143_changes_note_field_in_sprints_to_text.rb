class ChangesNoteFieldInSprintsToText < ActiveRecord::Migration
  def up
	change_column :sprints, :note, :text
  end

  def down
	change_column :sprints, :note, :string
  end
end
