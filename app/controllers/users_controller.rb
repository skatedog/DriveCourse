class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_and_set_current_user, except: [:index, :show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
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

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private
    def ensure_and_set_current_user
      @user = current_user
      if @user.id != params[:id].to_i
        redirect_to root_path
      end
    end

    def user_params
      params.require(:user).permit(:user_image, :name, :email, :introduction)
    end
end
