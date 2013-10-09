class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.where(email: params[:email].downcase)[0]
    
    if user && user.authenticase(params[:password])
      sign_in user
      redirect_to :home
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end
