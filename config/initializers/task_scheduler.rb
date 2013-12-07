include UsersHelper

# This automatically calls courses_to_email every minute
#scheduler = Rufus::Scheduler.new

#scheduler.every("1m") do
#  User.all.each{|u| UsersHelper.courses_to_email(u)}
#end 