class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
    @user = User.new(user_params)
    @user

    if @user.save
      log_in(@user)
      redirect_to '/plans'
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
    p "*" * 130
    p user_params
    p "*" * 130
    if @user.update(user_params)
      redirect_to plans_path
    else
      flash[:error] = @user.errors.full_messages
      render 'edit', :locals => {:id => @user.id}
    end

  end

  def destroy
    @user = User.find(params[:id])
    log_out()
    @user.destroy
    redirect_to root_path
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
