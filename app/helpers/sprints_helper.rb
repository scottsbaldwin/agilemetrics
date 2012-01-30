module SprintsHelper
	def man_days(sprint)
		days = sprint.team_size * sprint.working_days - sprint.pto_days
		days
	end

	def points_per_person_day(sprint)
		metric = sprint.actual_velocity / man_days(sprint)
		metric
	end

	def effective_team_size(sprint)
		# make sure we have values
		sprint.team_size = sprint.team_size ? sprint.team_size : 0
		sprint.working_days = sprint.working_days ? sprint.working_days : 0
		sprint.pto_days = sprint.pto_days ? sprint.pto_days : 0

		# get man days first
		the_man_days = man_days(sprint)
		week_days = sprint.team.sprint_weeks * 5

		# calculate team size
		team_size = the_man_days / week_days
		team_size.round(1)
	end

	def last_n_sprints(sprints, max_nr)
		complete_sprints = sprints.select { |sprint| sprint_is_complete?(sprint) }
		complete_sprints.last max_nr
	end

	def last_complete_sprint(sprints)
		completed = nil
		sprints.reverse_each do |sprint|
			if sprint_is_complete?(sprint)
				completed = sprint
				break
			end
		end
		completed
	end

	def sprint_is_complete?(sprint)
		!sprint.sprint_name.blank? && sprint.sprint_name != nil &&
		!sprint.end_date.blank? && sprint.end_date != nil &&
		!sprint.team_size.blank? && sprint.team_size != nil &&
		!sprint.working_days.blank? && sprint.working_days != nil &&
		!sprint.pto_days.blank? && sprint.pto_days != nil &&
		!sprint.planned_velocity.blank? && sprint.planned_velocity != nil &&
		!sprint.actual_velocity.blank? && sprint.actual_velocity != nil &&
		!sprint.adopted_points.blank? && sprint.adopted_points != nil &&
		!sprint.unplanned_points.blank? && sprint.unplanned_points != nil && 
		!sprint.found_points.blank? && sprint.found_points != nil &&
		!sprint.partial_points.blank? && sprint.partial_points != nil
	end

	def committed_velocity(sprint)
		found = sprint.found_points > 0 ? sprint.found_points : 0
		velocity = sprint.planned_velocity + sprint.adopted_points + sprint.unplanned_points + found
		velocity
	end

	def capacity(sprint)
		capacity = sprint.actual_velocity + sprint.partial_points
		capacity
	end

	def focus_factor(sprint)
		focus_factor = sprint.actual_velocity / capacity(sprint)
		# Present it as a whole number instead of a decimal
		focus_factor.round(2) * 100
	end

	def commitment_accuracy(sprint)
		accuracy = sprint.actual_velocity / committed_velocity(sprint)
		accuracy.round(2) * 100
	end

	def estimation_accuracy(sprint)
		accuracy = 1 - (sprint.found_points.abs / committed_velocity(sprint))
		accuracy.round(2) * 100
	end

	def unplanned_work_percent(sprint)
		unplanned = sprint.unplanned_points / sprint.planned_velocity
		unplanned.round(2) * 100
	end

	def velocity_efficiency(sprint, first_sprint)
		pts_per_person_day = points_per_person_day(sprint)
		if first_sprint != nil
			orig_pts_per_person_day = points_per_person_day(first_sprint)
			if orig_pts_per_person_day != 0
				efficiency = pts_per_person_day / orig_pts_per_person_day
				efficiency.round(2)
			else
				0
			end
		end
	end

	def average_velocity(sprints, current_sprint, n)

		# find the current sprint
		idx = sprints.index { |sprint| sprint.sprint_name == current_sprint.sprint_name }
		# get the set of the last n sprints
		set = sprints[0, idx+1].last(n)
		# find the average over the last n sprints
		sum = 0
		set.each { |sprint| sum += sprint.actual_velocity if sprint.actual_velocity != nil }
		avg = 0
		avg = sum / set.size if set.size > 0
	end

	def velocity_index(sprint, first_sprint)
		idx = sprint.actual_velocity / first_sprint.actual_velocity
		idx.round(2)
	end
end
