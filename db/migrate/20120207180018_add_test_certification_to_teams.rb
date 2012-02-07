class AddTestCertificationToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :test_certification, :integer, :default => 0

  end
end
