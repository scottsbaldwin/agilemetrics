class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :sprint_name
      t.date :end_date
      t.float :team_size
      t.float :working_days
      t.float :pto_days
      t.float :planned_velocity
      t.float :actual_velocity
      t.float :adopted_points
      t.float :unplanned_points
      t.float :found_points
      t.float :partial_points

		t.references :team

      t.timestamps
    end

	add_index :sprints, :team_id
  end
end
