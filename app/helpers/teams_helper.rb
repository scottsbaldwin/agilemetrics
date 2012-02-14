module TeamsHelper
	def is_username_an_owner_of_team?(username, team)
		result = false

		if username != nil && team != nil && team.owners != nil
			result = team.owners.include?(username)
		end

		result ||= is_super_admin?(username)
		
		return result
	end

	def get_css_class_for_upper_threshold(value)
		if value >= 80
			css_class = "ok"
		else
			css_class = "poor"
		end
		css_class
	end

	def get_css_class_for_lower_threshold(value)
		if value < 20
			css_class = "ok"
		else
			css_class = "poor"
		end
		css_class
	end

	def get_css_class_for_velocity_efficiency(value)
		if value < 1
			css_class = "poor"
		else
			css_class = "ok"
		end
		css_class
	end
end
