#
# Provides methods to help with managing sessions.
#
# Based heavily on the Sessions helper in the Ruby on Rails tutorial by Michael Hartl at:
# http://ruby.railstutorial.org/
#
# Author: Branden Ogata
#

module SessionsHelper
  #
  # Signs in the user.
  #
  # Parameters:
  #   user    The User to be signed in.
  #
  
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end
  
  #
  # Indicates whether the current user is signed in.
  #
  # In order for the current user to be signed in, there must be a current user,
  # thus the check if current_user is nil.
  #
  # Returns:
  #   A boolean value that is true if a user is signed in,
  #                           false otherwise.
  #
  
  def signed_in?
    puts "Current User: #{current_user}"
    !current_user.nil?
  end
  
  #
  # Signs out a user.
  #
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  #
  # Sets a user to be the current user.
  #
  # Parameters:
  #   user    The user to set as the current user.
  #
  
  def current_user=(user)
    @current_user = user
  end
  
  #
  # Indicates whether a user is the current user.
  #
  # Parameters:
  #   user    The User to check.
  #
  # Returns:
  #   A boolean value that is true if the parameter user is the current user,
  #                           false otherwise.
  #
  
  def current_user?(user)
    user == current_user
  end
  
  #
  # Returns the current user.
  #
  # Returns:
  #   The User whose security token matches the current security token.
  #
  
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.where(remember_token: remember_token)[0]
  end
  
  #
  # Verifies that the user is signed in.
  #
  # This can be used to prevent the user from accessing certain pages without logging in first;
  # if the user is not signed in, then he or she is redirected to the sign in page.
  #
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to :signin, notice: "Please sign in."
    end
  end
end
