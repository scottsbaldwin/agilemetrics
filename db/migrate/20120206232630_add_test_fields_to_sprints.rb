class AddTestFieldsToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :code_coverage, :float, :default => 0

    add_column :sprints, :nr_manual_tests, :integer, :default => 0

    add_column :sprints, :nr_automated_tests, :integer, :default => 0

  end
end
