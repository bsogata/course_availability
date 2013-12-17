#
# The sessions controller.
#
# Based heavily on the Sessions controller in the Ruby on Rails tutorial by Michael Hartl at:
# http://ruby.railstutorial.org/
#
# Author: Branden Ogata
#

class SessionsController < ApplicationController
  #
  # The signin page.
  #
  
  def new
  end
  
  #
  # Creates a new session, signing in the user.
  #
  
  def create
    user = User.where(email: params[:session][:email].downcase)[0]
    reset_session
    
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  #
  # Destroys a session, signing out the user.
  #
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
