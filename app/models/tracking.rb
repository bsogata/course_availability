# == Schema Information
#
# Table name: trackings
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tracking < ActiveRecord::Base
end
