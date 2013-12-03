module UsersHelper

	def self.perform(user)
		@user = user
		@frequent_value = @user.frequency_value
		@frequent = @user.frequency
		
		#Initial idea of testing if it is daily selection
		if @frequent == 'daily'
			if Time.now == Time.beginning_of_day
		   		CoursMailer.notify_email(@user)
		   		Resque.enqueue(Time.beginning_of_day(), @user, @frequenct)
		   	end
		# Minute selection
		elsif @frequent == 'min'
			# Currently the closest function for finding the current minute and add the value 
			# from the user
		    @time = Time.now + @frequent_value.minutes
		    
		    if Time.now == @time
		    	# The part to send out email, might also have to put in another variable to grab
		    	# the courses the user has tracked.
				CoursMailer.notify_email(@user)
				Resque.enqueue(@time, @user, @frequent)
			end
		# Hour selection
		elsif @frequent == 'hr'
			# Currently the closest function for finding the current hour and add the value 
			# from the user
			@time_hours = Time.now + @frequent_value.hours
			
			if Time.now == @time_hours 
				# The part to send out email, might also have to put in another variable to grab
		    	# the courses the user has tracked.
				CoursMailer.notify_email(@user)
				Resque.enqueue(@time_hours, User, @frequency)
			end
		end
		
	end
	
end
