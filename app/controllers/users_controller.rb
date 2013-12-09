class UsersController < ApplicationController
  include ActionView::Helpers::TextHelper
  include UsersHelper
  before_filter :signed_in_user, only: [:edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]
  
  def new
    if signed_in?
      redirect_to root_path
    else
      @user = User.new
    end  
  end
  
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
  
  def show
    @user = User.find(params[:id])
    @trackings = Tracking.where(user_id: @user.id)
  end
  
  def edit
  end
  
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
  
  def destroy
    User.find(params[:id]).delete
    Tracking.where(user_id: params[:id]).delete_all
    flash[:success] = "Deleted account"
    redirect_to root_path
  end
  
  private
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :frequency, :frequency_value)
  end
end
