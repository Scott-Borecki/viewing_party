class UsersController < ApplicationController
  def show
    require "pry"; binding.pry

  end

  def new
    @user = User.new
  end

  def create
    user = user_params
    user[:email] = user[:email].downcase
    new_user = User.new(user)
    if new_user.save
      flash[:success] = "Welcome, #{new_user.email}!"
      require "pry"; binding.pry
      session[:user_id] = new_user.id
      redirect_to '/dashboard'
    else
      flash[:failure] = "Something went horribly wrong!"
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
