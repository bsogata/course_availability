include ActionView::Helpers::TextHelper

class SearchesController < ApplicationController

  def create
    # Actual search should be performed in index
    flash[:search] = params[:search]
    redirect_to searches_path
  end
  
  def index
    # This will display the results of the search
    @matches = []
    base_url = "https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN&t=201430&s="
    
    # If the search parameters contain "ICS", "MATH", or "PSY",
    # only search in that department
    case flash[:search]
      when /ICS/i
        @matches = view_context.search_at_url("#{base_url}ICS", flash[:search])
      when /MATH/i
        @matches = view_context.search_at_url("#{base_url}MATH", flash[:search])
      when /PSY/i
        @matches = view_context.search_at_url("#{base_url}PSY", flash[:search])
      else
        @matches = view_context.search_at_url("#{base_url}ICS", flash[:search])
        @matches += view_context.search_at_url("#{base_url}MATH", flash[:search])
        @matches += view_context.search_at_url("#{base_url}PSY", flash[:search])
    end
    
    if @matches.empty?
      flash.now[:error] = "No results found for #{flash[:search]}"
    else
      flash.now[:success] = "#{@matches.count} results found for \"#{flash[:search]}\""
    end
    
    @search_term = flash[:search]
    
    flash.delete(:search)
  end
end
