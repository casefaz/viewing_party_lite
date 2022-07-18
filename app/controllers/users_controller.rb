class UsersController < ApplicationController
  def new
    @user = User.new
  end


  def show
    @user = User.find(params[:id])
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      flash[:success] = "Welcome, #{new_user.email}!"
      redirect_to user_path(new_user.id)
    else
      redirect_to register_path, alert: "Cannot register, missing or repeated information"
   end 
  end

  def discover
    @user = User.find(params[:user_id])
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
