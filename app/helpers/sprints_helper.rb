require 'linearregression'
require 'enumextensions'

module SprintsHelper
	def man_days(sprint)
		team_size = sprint.team_size != nil ? sprint.team_size : 0
		working_days = sprint.working_days != nil ? sprint.working_days : 0
		pto_days = sprint.pto_days != nil ? sprint.pto_days : 0
		days = team_size * working_days - pto_days
		days
	end

	def points_per_person_day(sprint)
		man_days_denominator = man_days(sprint)
		metric = 0
		if man_days_denominator != 0
			metric = sprint.actual_velocity / man_days_denominator
		end
		metric
	end

	def get_linear_regression_actual_velocity(sprints, sprint)
		previous_sprints = sprints.select { |s| s.sprint_name < sprint.sprint_name && sprint_is_complete?(s) }
		previous_sprints = previous_sprints.last(10)

		actual_velocities = []
		if previous_sprints != nil && previous_sprints.length > 0
			actual_velocities = previous_sprints.map { |sprint| sprint.actual_velocity }
		end
	
		linear_regression = LinearRegression.new actual_velocities
		return linear_regression
	end

	def next_velocity_in_trend(linear_regression)
		rate = linear_regression.slope.round(1)
		reate = 0 if rate == 0
		# if the growth rate (slope) is better than 0 then give
		# the target to the next in the trend
		if rate >= 0
			linear_regression.next.ceil
		else
			# if the growth rate is negative, find out what
			# is needed to correct the behavior and stabilize at 0
			linear_regression.stabilize_over_n_values(10).ceil
		end
	end

	def velocity_growth(linear_regression)
		rate = linear_regression.slope.round(1)
		prefix = ""
		prefix = "+" if rate > 0
		# get rid of the - sign when the unrounded number was negative
		rate = 0 if rate == 0
		growth = ""
		growth = pluralize "%s%s" % [ prefix, rate ], "pt" if !rate.to_f.nan?
		growth
	end

	def maintain_target(sprints, sprint)
		# Get the previous sprints
		previous_sprints = sprints.select { |s| s.sprint_name < sprint.sprint_name && sprint_is_complete?(s) }
		previous_sprints = previous_sprints.last(6)

		# find the maximum points per day over the previous sprints
		pts_per_person_day_array = previous_sprints.map { |s| points_per_person_day(s) }
		pts_per_person_day_array.sort!
		max_pts = pts_per_person_day_array.pop

		# pts per person day of previous sprint * man days of current sprint
		target = max_pts * man_days(sprint) if max_pts != nil && sprint != nil 
		if target != nil
			target.round(0)
		else
			0
		end
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

	def last_n_sprints_inclusive(sprints, current_sprint, n)
		# find the current sprint
		idx = sprints.index { |sprint| sprint.sprint_name == current_sprint.sprint_name }
		if idx == nil
			return []
		end
		# get the set of the last n sprints
		set = sprints[0, idx+1].last(n)
		# get only those that are complete
		set = last_n_sprints(set, n)
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

	def rolling_average_velocity(sprints, current_sprint, n)
		set = last_n_sprints_inclusive(sprints, current_sprint, n)
		average_velocity(set)
	end

	def average_velocity(set)
		values = set.map { |s| s.actual_velocity }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(1)
		else
			0
		end
	end

	def average_capacity(set)
		values = set.map { |s| capacity(s) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(0)
		else
			0
		end
	end

	def average_focus_factor(set)
		values = set.map { |s| focus_factor(s) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(0)
		else
			0
		end
	end

	def average_commitment_accuracy(set)
		values = set.map { |s| commitment_accuracy(s) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(0)
		else
			0
		end
	end

	def average_estimation_accuracy(set)
		values = set.map { |s| estimation_accuracy(s) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(0)
		else
			0
		end
	end

	def average_unplanned_work(set)
		values = set.map { |s| unplanned_work_percent(s) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(0)
		else
			0
		end
	end

	def average_velocity_efficiency(set, first_sprint)
		values = set.map { |s| velocity_efficiency(s, first_sprint) }
		if values.length > 0
			statsArray = StatisticalArray.new(values)
			statsArray.average.round(2)
		else
			0
		end
	end

	def velocity_index(sprint, first_sprint)
		idx = sprint.actual_velocity / first_sprint.actual_velocity
		idx.round(2)
	end

	def confidence_interval(set)
		values = set.map {|s| s.actual_velocity }
		interval = "-"
		if values.length > 5
			statsArray = StatisticalArray.new(values)
			interval = "%d - %d" % [ statsArray.confidence_interval_low, statsArray.confidence_interval_high ]
		end
		return interval
	end
end
