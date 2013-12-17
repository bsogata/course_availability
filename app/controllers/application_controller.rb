include TrackingsHelper

#
# The controller for all pages.
#
# Author: Hansen Cheng
#         Branden Ogata
# 

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, except: [:create]
  include SessionsHelper
end
