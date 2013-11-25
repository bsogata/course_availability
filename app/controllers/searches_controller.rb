class SearchesController < ApplicationController

  def create
    # Actual search should be performed in index
    puts "params[:search]: #{params[:search]}"
    flash[:search] = params[:search]
    redirect_to searches_path
  end
  
  def index
    # This will display the results of the search
    puts "flash[:search]: #{flash[:search]}"
    @courses = Course.search(flash[:search])
    
    # If the search parameters contain "ICS", "MATH", or "PSY",
    # only search in that department
    case flash[:search]
      when /ICS/i
      when /MATH/i
      when /PSY/i
      else
    end
    
    puts "Courses: #{@courses}"
  end
end
