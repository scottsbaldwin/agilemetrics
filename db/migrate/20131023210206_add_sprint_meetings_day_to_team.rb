class AddSprintMeetingsDayToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :day_of_week_for_meetings, :integer, default: 5
  end
end
