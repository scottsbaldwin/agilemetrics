module ApplicationHelper
	def is_super_admin?(username)
		result = false
		super_admin_users = ::Rails.application.config.super_admin_users
		result = super_admin_users.include?(username) if super_admin_users != nil
		result
	end
end
