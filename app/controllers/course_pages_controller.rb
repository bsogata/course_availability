class CoursePagesController < ApplicationController 
  
  def home
  end
  
  def help
  end 
  
  def new 
  	@course_list = Course.new("1", "ICS")
  	@course_list.save
  	render 'new'
  end
  
  
end
