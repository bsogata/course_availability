require 'nokogiri'
require 'open-uri'

module TrackingsHelper
  def get_semesters
#    uri = URI('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN')
#    
#    Net::HTTP.start(uri.host, uri.port,
#      :use_ssl => uri.scheme == 'https') do |http|
#      request = Net::HTTP::Get.new uri
#   
#      response = http.request request # Net::HTTPResponse object
#      puts response.body
#    end
    semesters = []

    doc = Nokogiri::HTML(open('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN'))
    doc.css('a').each do |a|
      if a.content.include?("Spring") || a.content.include?("Summer") || a.content.include?("Fall")
        semesters.push([a.content, a.get_attribute('href')])
      end
    end
    
    return semesters
  end
  
  def get_departments
    uri = URI('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN')
    
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
    
      response = http.request request # Net::HTTPResponse object
      puts response.body
    end
    
    []
  end
  
  def get_courses
    uri = URI('https://www.sis.hawaii.edu/uhdad/avail.classes?i=MAN')
    
    Net::HTTP.start(uri.host, uri.port,
      :use_ssl => uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
    
      response = http.request request # Net::HTTPResponse object
      puts response.body
    end
    
    []
  end
end
