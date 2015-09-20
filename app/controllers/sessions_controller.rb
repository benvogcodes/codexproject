class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(:username => params[:session][:username])
    if (@user && @user.password == params[:password])
      session[:user_id] = @user.id
      puts '********************'
      puts session[:user_id]
      puts '********************'
      redirect_to @user
    else
      render 'sessions/new'
    end
  end

  def destroy
    session.destroy
    redirect_to '/'
  end

end
