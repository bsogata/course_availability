# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :text
#  crn        :integer
#  section    :integer
#  title      :text
#  credits    :integer
#  instructor :text
#  seats      :integer
#  days       :text
#  time       :text
#  room       :text
#  dates      :text
#  created_at :datetime
#  updated_at :datetime
#

class Course < ActiveRecord::Base
	
end
