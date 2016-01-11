class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "You have been logged in!"
    else
      @user = User.new
      flash.now[:error] = "Bad Username or Password"
      render :new
    end
  end

  def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "You have been logged out!"
  end
end
