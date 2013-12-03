class SessionsController < ApplicationController
  def new
  end
  
  def create
    response.headers['X-CSRF-Token'] = form_authenticity_token    
    user = User.where(email: params[:session][:email].downcase)[0]
    
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
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
