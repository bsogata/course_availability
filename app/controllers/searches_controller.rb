class SearchesController < ApplicationController

  def create
    # Actual search should be performed here
    puts "params[:search]: #{params[:search]}"
    flash[:search] = params[:search]
    redirect_to searches_path
  end
  
  def index
    # This will display the results of the search
    puts "flash[:search]: #{flash[:search]}"
    @courses = Course.search(flash[:search])
    puts "Courses: #{@courses}"
  end
end
