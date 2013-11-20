require 'nokogiri'
require 'open-uri'

module TrackingsHelper
  #
  # Returns the semesters for which courses are listed on the UH Course Availability site.
  #
  # Returns:
  #   An array containing pairs of semesters and links to semester course pages.
  #
  
  def get_semesters
    semesters = []

    doc = Nokogiri::HTML(open('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN'))
    doc.css('a').each do |a|
      if a.content.include?("Spring") || a.content.include?("Summer") || a.content.include?("Fall")
        semesters.push([a.content, 'https://www.sis.hawaii.edu/uhdad/' + a.get_attribute('href')])
      end
    end
    
    return semesters
  end
  
  #
  # Returns the departments offering courses in a given semester.
  #
  # Parameters:
  #   semester    The link to the semester page to find departments for.
  #
  # Returns:
  #   An array containing pairs of departments and links to department course pages. 
  #
  
  def get_departments(semester)
    departments = []
    doc = Nokogiri::HTML(open(semester[1]))
    doc.css('a').each do |a|
      departments.push([a.content,
                        'https://www.sis.hawaii.edu/uhdad/' +
                        a.get_attribute('href')]) if a.get_attribute('href').include?("&s=")
    end
    
    return departments
  end
  
  #
  # Returns the list of courses for a given department in a semester.
  #
  # Parameters:
  #   department    The link to the department page to find courses for.
  #
  # Returns:
  #   An array containing names of courses. 
  #
  
  def get_courses(department)
    courses = []
    
#    puts "Department: #{department}"

    doc = Nokogiri::HTML(open(department[1]))
    
    # Parse header to find the course column
    course_column = 0
    current_column = 0
    doc.css('th').each do |th|
      course_column = current_column if th.content != 'Course'
      current_column += 1
    end
    
    return courses
  end
  
  #
  # Returns the HTML of a course page for a given department in a semester.
  #
  # Parameters:
  #   department    The link to the department page to get HTML from.
  #
  # Returns:
  #   A string containing the HTML of the given department page. 
  #
  
  def get_course_page(department)
    puts Nokogiri::HTML(open(department[1])).css('table.listOfClasses')
    return Nokogiri::HTML(open(department[1])).css('table.listOfClasses')
  end
  
  #
  # Returns the courses for the ICS, Math, and Psychology departments in Spring 2014.
  #
  # The above methods demonstrate that it is possible to get all courses on the site,
  # but this is a very slow processes; consequently, this only looks at three departments
  #
  # Returns:
  #   A two-dimensional array containing the courses for each department.
  #
  
  def get_test_courses
    return [get_courses_in_page('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=ICS'),
            get_courses_in_page('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=MATH'),
            get_courses_in_page('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=PSY')]
  end
  
  #
  # Returns all courses in the given URL.
  #
  # Parameters:
  #   url    The string containing the URL to open and find courses in.
  #
  # Returns:
  #   An array containing the courses in the given page.
  #
  
  def get_courses_in_page(url)
    courses = []
    page = Nokogiri::HTML(open(url))
    course = ''
    section = ''
    department = url[url.rindex('=') + 1 ... url.length]
    
    page.css('td').each do |td|
      case td.content
        when /^#{department} \d{3}.?$/
          course = td.content
        when /^\d{3}$/
          section = td.content
        else  
      end
      
      if !course.empty? && !section.empty?
        courses.push "#{course}-#{section}"
        course = ''
        section = ''
      end
    end
    
    return courses
  end
  
  #
  # Returns the HTML of the appropriate course pages.
  #
  # Returns:
  #   An array containing the HTML code for the ICS, MATH, and PSY departments.
  #
  
  def get_department_pages
    return [Nokogiri::HTML(open('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=ICS')).css(".listOfClasses").to_s,
            Nokogiri::HTML(open('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=MATH')).css(".listOfClasses").to_s,
            Nokogiri::HTML(open('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=PSY')).css(".listOfClasses").to_s]
  end
end
