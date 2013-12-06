# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
CourseAvailability::Application.initialize!

#Settings to send email from Gmail account
ActionMailer::Base.smtp_settings = {
	:address	=> "smtp.gmail.com",
	:port		=> 587,
	:domain		=> "gmail.com",
	:user_name	=> ENV['username'],
	:password 	=> ENV['password'],
	:authentication	=> "plain",
	:enable_starttls_auto => true
}

