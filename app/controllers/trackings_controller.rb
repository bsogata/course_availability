require 'nokogiri'
require 'open-uri'

class TrackingsController < ApplicationController
  def create
    course_param = params[:course]
    department = params[:department]
    course = course_param[0 ... course_param.index('-')]
    section = course_param[course_param.index('-') + 1 ... course_param.length]
    
    # Now that the department, course, and section are identified,
    # parse through the appropriate department page
    url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{department}"
    page = Nokogiri::HTML(open(url))
    
    matches = page.css("tr").select {|tr| tr.content.include?(course) && tr.content.include?(section)}
        
    column_index = 0
    crn = 0
    name = ""
    section = ""
    title = ""
    credits = 0
    instructor = ""
    seats = 0
    days = ""
    time = ""
    room = ""
    dates = ""
    
    matches.first.css("td").each do |td| 
      case column_index
        when 1
          crn = td.content
        when 2
          name = td.content
        when 3
          section = td.content
        when 4
          title = td.content
        when 5
          credits = td.content
        when 6
          instructor = td.content
        when 7
          seats = td.content
        when 8
          days = td.content
        when 9
          time = td.content
        when 10
          room = td.content
        when 11
          dates = td.content
      end
      
      column_index += 1
    end
  
    # Check the (theoretically) unique elements for a match in Course first,
    # then add the other fields
    course = Course.find_or_create_by(crn: crn, name: name, section: section)
    course.title = title
    course.credits = credits
    course.instructor = instructor
    course.seats = seats
    course.days = days
    course.time = time
    course.room = room
    course.dates = dates
    course.save
    
    # Track the course if possible
    tracking = Tracking.where(user_id: current_user.id, course_id: course.id)
    
    if tracking.empty?
      Tracking.create(user_id: current_user.id, course_id: course.id)
    end
    
    # If the process was successful, flash success message
    if course.errors.empty? && tracking.empty?
      flash[:success] = "#{course_param} added to Tracking List"    
    # Else if the course was already being tracked, flash notification
    elsif !tracking.empty?
      flash[:notice] = "Already tracking #{course_param}"
    # Else if there was an error, flash error message
    else
      flash[:error] = "Error when tracking course: \n#{course.errors}"
    end
    redirect_to :back
  end
end
