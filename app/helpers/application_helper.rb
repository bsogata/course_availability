module ApplicationHelper
	# Initial code for the initializer to be executed after everything is loaded
	class Application < Rails::Application
		config.after_initialize do
			# Access each user's course and check if the seats changed
			# If it did then schedule it to send out email based on a scheduler
			# that is also based on the frequency of the user
		end
end
