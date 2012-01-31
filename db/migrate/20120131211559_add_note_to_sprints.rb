class AddNoteToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :note, :string

  end
end
