class UsersController < ApplicationController
  def new
    @user = User.new
  end


  def show
    @user = User.find(params[:id])
  end

  def create
    new_user = User.create(user_params)
    if new_user.save
      flash[:success] = "Welcome, #{new_user.email}!"
      redirect_to user_path(new_user.id)
    else
      flash[:error] = new_user.errors.full_messages
      redirect_to register_path
   end 
  end

  def discover
    @user = User.find(params[:user_id])
  end

  def login_form

  end

  def login_user
    # binding.pry
    user = User.find_by(email: params[:email])
    flash[:success] = "Welcome, #{user.email}!"
    redirect_to "/users/#{user.id}"
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
