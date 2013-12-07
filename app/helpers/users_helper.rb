module UsersHelper
    # Under development
    # 
    # This method accepts a input of a user variable and obtains the
    # frequency value and the frequency e.g. daily, min, or hr.
    # 
    # Based on the frequency it uses a scheduler to send out emails.
    #
    # As of now it sends email based on frequency, but not based on
    # if the seats have been deducted.
    #
	def perform(user)
		@user = user
		@frequent_value = @user.frequency_value
		@frequent = @user.frequency
		scheduler = Rufus::Scheduler.new
		
		#Initial idea of testing if it is daily selection
		if @frequent == 'daily'
			
			scheduler.every(@frequent_value.to_s() + "d") do
				CourseMailer.notify_email(@user).deliver
		   	end
		# Minute selection
		elsif @frequent == 'min'
		    
			scheduler.every(@frequent_value.to_s() + "m") do
				CourseMailer.notify_email(@user).deliver
			end
		# Hour selection
		elsif @frequent == 'hr'
			
			scheduler.every(@frequent_value.to_s() + "h") do
				CourseMailer.notify_email(@user).deliver
			end
		end
		
	end
	
	#
	# Returns an array containing courses to send notifications for.
	#
	# There are two possible cases where it is necessary to send a message to the user:
	# when seats become available (zero seats to non-zero seats) and
	# when seats become completely filled (non-zero seats to zero seats).
	# All other changes are irrelevant.
	#
	# This method has the side effect of updating the Course table with the new number of seats
	# regardless of whether any courses are returned.
	#
	# Parameters:
	#   user    The User whose courses to check.
	#
	# Returns:
	#   An array containing Course instances to send notifications for.
	#
	
  def courses_to_email(user)
    courses = []
    
    # For each course that the user is tracking
    Tracking.where(user_id: user.id).each do |t|
      course = Course.find(t.course_id)
      seats = course.seats
      
      # Check the UH Course Availability site for an updated seat count
      url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{course.name[0..course.name.index(' ')]}"
      page = Nokogiri::HTML(open(url)).css('table.listOfClasses')
      
      match = page.css("tr").select {|tr| tr.content.include?(course.name) &&
                                          tr.content.include?(course.section)}.first
      current_seats = match.css("td")[7]
      
      # If transition between zero and non-zero, then send email
      if (seats != current_seats) && ((seats == 0) || (current_seats == 0))
        courses.push course
      end
      
      # Update the Course in the database
      course.seats = current_seats.to_i
      course.save
      
    end
    
    return courses
  end
end
