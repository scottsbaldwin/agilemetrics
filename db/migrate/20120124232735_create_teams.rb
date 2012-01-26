class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :sprint_weeks

      t.timestamps
    end
  end
end
