class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.email}!"
      redirect_to "/dashboard"
    else
      flash[:error] = "Incorrect credentials"
      redirect_to '/login'
    end 
  end

  def destroy
    session.destroy
    redirect_to root_path
  end
end