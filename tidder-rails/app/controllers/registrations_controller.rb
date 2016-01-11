class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    binding.pry
    form_fields = params.permit(:name,:username, :password, :password_confirmation)
    @user = User.new(form_fields)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Thank you for signing up"
    else
      render :new
    end
  end
end
