class TrackingsController < ApplicationController
  def create
    course_param = params[:course]
    department = params[:department]
    course = course_param[0 ... course_param.index('-')]
    section = course_param[course_param.index('-') + 1 ... course_param.length]
    
    # Now that the department, course, and section are identified,
    # parse through the appropriate department page
    url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s=#{department}"
    page = Nokogiri::HTTP(open(url))
    
    matches = page.css("tr").select {|tr| tr.content.include?(course) && tr.content.include?(section)}
    
    puts matches
    
    redirect_to :back
  end
end
