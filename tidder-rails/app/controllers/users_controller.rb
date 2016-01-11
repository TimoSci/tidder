class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(params[:user])
    redirect_to user_path(user)
  end

  def destroy
    user = User.find(params[:id])
    user.destroy_full
    redirect_to users_path
  end

end
