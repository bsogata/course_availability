class SearchesController < ApplicationController

  def create
    # Actual search should be performed here
    render 'show'
  end
  
  def show
    # This will display the results of the search
  end
end
