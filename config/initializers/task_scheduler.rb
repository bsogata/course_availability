include UsersHelper
require 'nokogiri'
require 'open-uri'

# This automatically calls courses_to_email every minute
scheduler = Rufus::Scheduler.new

#scheduler.every("1m") do
#  # The list of relevant course IDs
#  courses = []
#  
#  # For each department that this application handles
#  ['ICS', 'MATH', 'PSY'].each do |d|
#    # Get the URL of the department page
#    url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{d}"
#    page = Nokogiri::HTML(open(url)).css('table.listOfClasses')
#    
#    # For each course in the database that begins with the department name
#    Course.all.each do |c|
#      if c.name.start_with?(d)
#        # Find the course on the department page
#        match = page.css("tr").select {|tr| tr.content.include?(c.name) &&
#                                            tr.content.include?("%03d" % c.section)}
#        
#        # If a match was found (should always be true, but just in case to avoid nil values)
#        unless match.empty?
#          # Compare the number of seats on the UH site to those in the database
#          # Column 7 should always be the number of seats available
#          current_seats = match.first.css('td')[7].text.to_i
#          courses.push(c.id) if (c.seats != current_seats) && ((c.seats == 0) ||
#                                                               (current_seats == 0))
#          # Update the database
#          c.seats = current_seats
#          c.save
#        end
#      end
#    end
#  end
#  
#  # Check each User to determine if he or she is tracking a relevant course
#  User.all.each do |u|
#    tracked_courses = []
#    
#    Tracking.where(user_id: u.id).each do |t|
#      tracked_courses.push(Course.find(t.course_id)) if courses.include?(t.course_id)
#    end
#    
#    CourseMailer.notify_email(u, tracked_courses).deliver unless tracked_courses.empty?
#  end
#end 

# For testing purposes. This code starts off with a scheduler to check every 2 min. 
# The code is similar to the above code with the difference
# at the part where it checks if the user has relavant courses. If it does then 
# it will push it to the array and then later on check the frequency to send it out 
# on a schedule.
#
# Might not work as expected. 
scheduler.every("2m") do
  # The list of relevant course IDs
  courses = []
  
  # For each department that this application handles
  ['ICS', 'MATH', 'PSY'].each do |d|
    # Get the URL of the department page
    url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{d}"
    page = Nokogiri::HTML(open(url)).css('table.listOfClasses')
    
    # For each course in the database that begins with the department name
    Course.all.each do |c|
      if c.name.start_with?(d)
        # Find the course on the department page
        match = page.css("tr").select {|tr| tr.content.include?(c.name) &&
                                            tr.content.include?("%03d" % c.section)}
        
        # If a match was found (should always be true, but just in case to avoid nil values)
        unless match.empty?
          # Compare the number of seats on the UH site to those in the database
          # Column 7 should always be the number of seats available
          current_seats = match.first.css('td')[7].text.to_i
          courses.push(c.id) if (c.seats != current_seats) && ((c.seats == 0) ||
                                                               (current_seats == 0))
          # Update the database
          c.seats = current_seats
          c.save
        end
      end
    end
  end
  
  # Check each User to determine if he or she is tracking a relevant course
  User.all.each do |u|
    tracked_courses = []
    
    Tracking.where(user_id: u.id).each do |t|
      tracked_courses.push(Course.find(t.course_id)) if courses.include?(t.course_id)
    end
    
    # These lines of codes are currently to test if it works to send out notification if the
    # seats changes, but on a schedule time.
    if u.frequency == 'day'
    	scheduler.in(u.frequency_value.to_s() + "d") do
    		CourseMailer.notify_email(u, tracked_courses).deliver unless tracked_courses.empty?
    	end
    elsif u.frequency == 'min'
    	scheduler.in(u.frequency_value.to_s() + "m") do
			CourseMailer.notify_email(u, tracked_courses).deliver unless tracked_courses.empty?
		end
	elsif u.frequency == 'hr'
		scheduler.in(u.frequency_value.to_s() + "h") do
			CourseMailer.notify_email(u, tracked_courses).deliver unless tracked_courses.empty?
		end
	end
  end
end 