module UsersHelper

	def sending(user)
		@user = user
		@frequency_value = User.find(:frequency_value)
		@frequency = User.find(:frequency)
		
		#Initial idea of testing which 
		if @frequency == 'daily'
		   CoursMailer.notify_email(@user)
		elsif @frequency == 'min' || @frequency == 'hrs'
			CoursMailer.notify_email(@user)
		end
		
	end
	
end
