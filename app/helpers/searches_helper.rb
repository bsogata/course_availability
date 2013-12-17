require 'nokogiri'
require 'open-uri'

#
# Contains methods to help when searching for courses on the UH Course Availability site.
#
# Author: Branden Ogata
#

module SearchesHelper
  #
  # Returns all matches for the target within the HTML in the given URL.
  #
  # Parameters:
  #   url       The string containing the URL to get HTML from.
  #   target    The string containing the text to search for.
  #
  # Returns:
  #   A two-dimensional array containing search matches.
  #
  
  def search_at_url(url, target)
    page = Nokogiri.HTML(open(url))
    matching_rows = []
    
    # For each search term
#    target.split(" ").each do |t|
#      # Add matching rows if they have not already been selected
#      page.css("table.listOfClasses > tr").each do |tr|
#        matching_rows.push tr if tr.content.include?(t) && !matching_rows.include?(tr)
#      end
#    end
   
    # Add rows if they match all search criteria
    page.css("table.listOfClasses > tr").each do |tr|
      matches_all_targets = true
      
      target.downcase.split(' ').each do |t|
        matches_all_targets = matches_all_targets &&
                              tr.content.downcase.include?(t)
      end
      
      matching_rows.push tr if matches_all_targets
    end
    
    # Translate into somewhat more understandable (and more consistent) format
    matches = []
    
    matching_rows.each do |m|
      current = []
      column_count = 0
      
      m.css('td').each do |td|
        if (m.css('td').count == 12) ||
           (m.css('td').count == 14 && ((1..7).member?(column_count) || (10..13).member?(column_count)))
          if td.content.include?("Restriction:")
            current << td.content.insert(td.content.index("Restriction:"), "\n")
          else
            current << td.content
          end
        end
        
        column_count += 1
      end      
      matches.push current
      
      # If the row after this is a lab, include it as well
      rest_of_page = page.to_s[page.to_s.index(m.to_s) + m.to_s.length ...
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
        
        # Append the lab data onto the corresponding fields
        current[search_indices[:days]] += "\n#{lab_days}"
        current[search_indices[:time]] += "\n#{lab_time}"
        current[search_indices[:room]] += "\n#{lab_room}"
        current[search_indices[:dates]] += "\n#{lab_dates}"
      end
    end
    
    return matches
  end
  
  #
  # Returns an hash of column indices.
  #
  # These indices are arbitrary and correspond to the positions assigned in the
  # search_at_url method.
  #
  # Returns:
  #   A hash containing integers corresponding to certain columns.
  #
  
  def search_indices
    indices = Hash.new
    indices[:crn] = 0
    indices[:name] = 1
    indices[:section] = 2
    indices[:title] = 3
    indices[:credits] = 4
    indices[:instructor] = 5
    indices[:seats] = 6
    indices[:days] = 7
    indices[:time] = 8
    indices[:room] = 9
    indices[:dates] = 10
    
    return indices
  end
end
