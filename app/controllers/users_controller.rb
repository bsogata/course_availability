class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  
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
      
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Course Availability Tool!"
        CourseMailer.welcome_email(@user).deliver
        redirect_to @user
      else
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
      redirect_to @user
    else
      error_message = "Error when updating user information:<br />"
      current_user.errors.full_messages.each {|e| error_message += "#{e}<br />"}
      flash.now[:error] = error_message.html_safe;
      render 'edit'
    end
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
