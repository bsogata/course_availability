include UsersHelper

class CourseMailer < ActionMailer::Base
  default from: "UH Course"
  
  # Method to send out an welcome email to the user when they first create his/her account.
  #
  # Parameter: user - the user object created when the account is created.
  def welcome_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to UH Course Availability web application')
  end
  
  # Confirmation message to notify the user has added a particular class to the tracking list on their 
  # profile.
  #
  # Parameters: user - the user object created when the account was created
  #				course - the class the user specified for tracking
  def tracking_email(user, course)
		@user = user
		@course = course
		mail(to: @user.email, subject: "Now tracking #{@course.name + '-' +
																									 ("%03d" % @course.section)}")
  end
  
  # To send out notification email of the seats for particular classes that user have set 
  # for tracking.
  #
  # Parameters: user - the user object created when the account was created
  #             courses - the classes
  def notify_email(user, courses)
  	@user = user
  	@courses = courses
  	mail(to: @user.email, subject: "Notification Test") if !@courses.empty?
  end

end
