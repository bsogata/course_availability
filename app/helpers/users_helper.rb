module UsersHelper

	def self.perform(user)
		@user = user
		@frequency_value = User.find(:frequency_value)
		@frequency = User.find(:frequency)
		
		#Initial idea of testing if it is daily selection
		if @frequency == 'daily'
			if Time.now == Time.beginning_of_day
		   		CoursMailer.notify_email(@user)
		   		Resque.enqueue(Time.beginning_of_day(), User, @frequency)
		   	end
		# Minute selection
		elsif @frequency == 'min'
			# Currently the closest function for finding the current minute and add the value 
			# from the user
		    @time = Time.now + @frequency_value.minutes
		    
		    if Time.now == @time
				CoursMailer.notify_email(@user)
				Resque.enqueue(@time, User, @frequency)
			end
		# Hour selection
		elsif @frequency == 'hr'
			# Currently the closest function for finding the current hour and add the value 
			# from the user
			@time_hours = Time.now + @frequency_value.hours
			
			if Time.now == @time_hours 
				CoursMailer.notify_email(@user)
				Resque.enqueue(@time_hours, User, @frequency)
			end
		end
		
	end
	
end
