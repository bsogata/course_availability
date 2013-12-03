class SearchesController < ApplicationController

  def create
    response.headers['X-CSRF-Token'] = form_authenticity_token
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
      flash[:error] = "No results found for #{flash[:search]}"
    else
      flash[:success] = "#{@matches.count} results found for \"#{flash[:search]}\""
    end
    
    flash[:search].clear
  end
end
