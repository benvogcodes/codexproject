class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to plans_path
    else
      flash[:error] = ["Username or password is invalid."]
      render 'sessions/new'
    end
  end

  def destroy
    session.destroy
    redirect_to '/login'
  end
end
