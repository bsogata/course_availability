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
  
  def tracking_email(user, course)
		@user = user
		@course = course
		mail(to: @user.email, subject: "Now tracking #{@course.name + '-' +
																									 ("%03d" % @course.section)}")
  end
  
  # To send out notification email of the seats for particular classes
  #
  # Parameters: user - the user object created when the account is created
  #             courses - the classes
  def notify_email(user, courses)
  	@user = user
  	@courses = courses
  	mail(to: @user.email, subject: "Notification Test") if !@courses.empty?
  end

end
