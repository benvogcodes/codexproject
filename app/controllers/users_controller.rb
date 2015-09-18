class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
  end

  def index
  end

  private
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
