class UsersController < ApplicationController
  def new
    @user = User.new
  end


  def show
    if current_user
      @user = current_user
      @users = User.all
    else
      redirect_to root_path
      flash[:error] = "Please Log In First"
    end 
  end

  def create
    new_user = User.create(user_params)
    if new_user.save
      session[:user_id] = new_user.id
      flash[:success] = "Welcome, #{new_user.email}!"
      redirect_to '/dashboard'
    else
      flash[:error] = new_user.errors.full_messages
      redirect_to register_path
   end 
  end

  def discover
    @user = current_user
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
