class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
    @user

    if @user.save
      log_in(@user)
      redirect_to @user
    else
      flash[:error] = @user.errors.full_messages
      render 'new'
    end
  end

  def show
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(username: params[:user][:username], password_digest: params[:user][:password])
      redirect_to plans_path
    else
      render 'edit', :locals => {:id => @user.id}
    end

  end

  def index
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
