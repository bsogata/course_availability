class CourseMailer < ActionMailer::Base
  default from: "UH Course"
  
  def welcome_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to UH Course Availability web application')
  end
end
