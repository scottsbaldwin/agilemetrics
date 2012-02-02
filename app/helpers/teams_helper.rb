module TeamsHelper
	def is_username_an_owner_of_team?(username, team)
		result = false

		if username != nil && team != nil && team.owners != nil
			result = team.owners.include?(username)
		end
		
		return result
	end
end
