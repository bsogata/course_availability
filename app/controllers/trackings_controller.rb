require 'nokogiri'
require 'open-uri'

#
# The trackings controller.
#
# Author: Hansen Cheng
#         Branden Ogata
#

class TrackingsController < ApplicationController
  #
  # Creates a new Tracking relationship.
  #
  # Author: Branden Ogata
  #
  
  def create
    course_param = params[:course]
    department = params[:department]
    course = course_param[0 ... course_param.index('-')]
    section = course_param[course_param.index('-') + 1 ... course_param.length]
    
    # Now that the department, course, and section are identified,
    # parse through the appropriate department page
    url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{department}"
    page = Nokogiri::HTML(open(url))
    
    matches = page.css("tr").select {|tr| tr.content.include?(course) &&
                                          tr.content.include?(section)}
            
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
    
    column_count = matches.first.css("td").count
    
    matches.first.css("td").each do |td|
      # Before registration opens
      if column_count == 12
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
      # After registration opens
      elsif column_count == 14
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
          when 10
            days = td.content
          when 11
            time = td.content
          when 12
            room = td.content
          when 13
            dates = td.content
        end
      end
      
      column_index += 1
    end
    
    # Attempts to find lab if one exists on the line after the match
    rest_of_page = page.to_s[page.to_s.index(matches.first.to_s) + matches.first.to_s.length ...
                             page.to_s.length]
    next_row = rest_of_page[rest_of_page.index('<tr'), rest_of_page.index('</tr>') + 5]
    next_row_parser = Nokogiri.HTML(next_row)
    
    lab_days = ""
    lab_time = ""
    lab_room = ""
    lab_dates = ""
    lab_column_count = next_row_parser.css('td').count
    
    # Labs will have 11 or 13 columns depending on whether waitlist columns are present,
    # but the fields for the labs are always the last four
    if (lab_column_count == 11 || lab_column_count == 13)
      column_index = 0
      
      next_row_parser.css('td').each do |lab_column|
        case column_index
          when lab_column_count - 4
            lab_days = lab_column.content
          when lab_column_count - 3
            lab_time = lab_column.content
          when lab_column_count - 2
            lab_room = lab_column.content
          when lab_column_count - 1
            lab_dates = lab_column.content
        end
        column_index += 1
      end      
    end
  
    # Check the (theoretically) unique elements for a match in Course first,
    # then add the other fields
    course = Course.find_or_create_by(crn: crn, name: name, section: section)
    course.title = (title.include?("Restriction:")) ?
                   (title.insert(title.index("Restriction:"), "\n")) : (title)
    course.credits = credits
    course.instructor = instructor
    course.seats = seats
    course.days = days + ((lab_days.empty?) ? ("") : ("\n#{lab_days}"))
    course.time = time + ((lab_time.empty?) ? ("") : ("\n#{lab_time}"))
    course.room = room + ((lab_room.empty?) ? ("") : ("\n#{lab_room}"))
    course.dates = dates + ((lab_dates.empty?) ? ("") : ("\n#{lab_dates}"))
    course.save
    
    # Track the course if possible
    tracking = Tracking.where(user_id: current_user.id, course_id: course.id)
    already_tracking = tracking.empty?
    
    if already_tracking
      Tracking.create(user_id: current_user.id, course_id: course.id)
    end
    
    # If the process was successful, flash success message
    if course.errors.empty? && already_tracking
      flash[:success] = "#{course_param} added to Tracking List"
      CourseMailer.tracking_email(current_user, course).deliver
    # Else if the course was already being tracked, flash notification
    elsif !already_tracking
      flash[:notice] = "Already tracking #{course_param}"
    # Else if there was an error, flash error message
    else
      flash[:error] = "Error when tracking course: \n#{course.errors}"
    end
    redirect_to :back
  end
  
  #
  # Destroys a tracking relationship.
  #
  # If no other user is tracking the course of the tracking being deleted,
  # deletes the course as well to help clean up the database.
  #
  # Author: Branden Ogata
  #
  
  def destroy
    tracking = Tracking.find(params[:id])
    course = Course.find(tracking.course_id)
    course_name = "#{course.name}-#{"%03d" % course.section}"
    
    # Delete tracking, then delete course if it is no longer tracked anywhere else
    tracking.delete
    course.delete if Tracking.where(course_id: course.id).length == 0
    
    # If the deletion was successful, flash success message
    if tracking.errors.empty?
      flash[:success] = "Stopped tracking #{course_name}"
    # Else flash error message
    else
      flash[:error] = "Error when removing tracking for #{course_name}: \n#{tracking.errors}"      
    end
    
    redirect_to :back
  end
end