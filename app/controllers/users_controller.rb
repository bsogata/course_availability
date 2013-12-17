#
# The users controller.
#
# Based heavily on the User controller in the Ruby on Rails tutorial by Michael Hartl at:
# http://ruby.railstutorial.org/
#
# Author: Hansen Cheng
#         Branden Ogata
#

class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :signed_in_user, only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]
  
  #
  # The user creation page.
  #
  # Author: Branden Ogata
  #
  
  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end  
  end
  
  #
  # Creates a new user.
  #
  # Author: Hansen Cheng
  #         Branden Ogata
  #
  
  def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new(user_params)
      @user.frequency = "min"
      @user.frequency_value = 1;
      
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Course Availability Tool!"
        CourseMailer.welcome_email(@user).deliver
        redirect_to @user
      else
        error_message = "#{pluralize(@user.errors.count, 'error')}: <br />"
        @user.errors.full_messages.each {|e| error_message += "#{e} <br />"}
        flash.now[:error] = error_message.html_safe
        render 'new'
      end
    end
  end
  
  #
  # The profile page for the user.
  #
  # Author: Hansen Cheng
  #         Branden Ogata
  #
  
  def show
    @user = User.find(params[:id])
    @trackings = Tracking.where(user_id: @user.id)
  end
  
  #
  # The settings page for the user.
  #
  # The methods in the sessions helper mean that nothing needs to be set up here.
  #
  # Author: Branden Ogata
  #
  
  def edit
  end
  
  #
  # Updates user information.
  #
  # Author: Branden Ogata
  #
  
  def update
    for p in params[:user]
      puts p
    end
    
    if current_user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      # Currently disabled while developers test an alternate solution using initializers
#      perform(@user)
      redirect_to @user
    else
      error_message = "Error when updating user information:<br />"
      current_user.errors.full_messages.each {|e| error_message += "#{e}<br />"}
      flash.now[:error] = error_message.html_safe;
      render 'edit'
    end
  end
  
  #
  # Deletes a user account.
  #
  # Author: Branden Ogata
  #
  
  def destroy
    User.find(params[:id]).delete
    Tracking.where(user_id: params[:id]).delete_all
    flash[:success] = "Deleted account"
    redirect_to root_path
  end
  
  private
  
    #
    # Verifies that this user is the correct user.
    #
    # Author: Branden Ogata
    #
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    #
    # The list of available user fields.
    #
    # Author: Branden Ogata
    # 
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :frequency, :frequency_value)
    end
end
