module UsersHelper

	def self.perform(user)
		@user = user
		@frequent_value = @user.frequency_value
		@frequent = @user.frequency
		scheduler = Rufus::Scheduler.start_new
		
		#Initial idea of testing if it is daily selection
		if @frequent == 'daily'
			
			scheduler.every(@frequent_value + "d") do
				CourseMailer.notify_email(@user)
		   	end
		# Minute selection
		elsif @frequent == 'min'
		    
			scheduler.every(@frequent_value + "m") do
				CourseMailer.notify_email(@user)
			end
		# Hour selection
		elsif @frequent == 'hr'
			
			scheduler.every(@frequent_value + "h") do
				CourseMailer.notify_email(@user)
			end
		end
		
	end
	
end
