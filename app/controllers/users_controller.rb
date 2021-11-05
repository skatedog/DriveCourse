class UsersController < ApplicationController
  before_action :set_currrent_user, except: :index

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private
    def set_currrent_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:user_image, :name, :email, :introduction)
    end
end
