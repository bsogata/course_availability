module UsersHelper

	def self.perform(user)
		@user = user
		@frequency_value = User.find(:frequency_value)
		@frequency = User.find(:frequency)
		
		#Initial idea of testing which 
		if @frequency == 'daily'
			if Time.beginning_of_day()?
		   		CoursMailer.notify_email(@user)
		   		Resque.enqueue(Time.beginning_of_day(), User, @frequency)
		   	end
		elsif @frequency == 'min' || @frequency == 'hrs'
			#Figure out a way 
			CoursMailer.notify_email(@user)
		end
		
	end
	
end
