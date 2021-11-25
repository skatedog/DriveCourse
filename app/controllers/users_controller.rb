class UsersController < ApplicationController
  before_action :authenticate
  before_action :ensure_and_set_current_user, except: :show

  def show
    @user = User.find(params[:id])
    if !@user.is_private || @user == current_user
      @courses = @user.courses.order(created_at: :desc).page(params[:page])
    else
      redirect_to root_path
    end
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

  def like
    case params[:like]
    when "spot"
      @spots = current_user.like_spots.page(params[:page])
    when "course"
      @courses = current_user.like_courses.page(params[:page])
    end
  end

  private
    def ensure_and_set_current_user
      @user = current_user
      if @user.id != params[:id].to_i
        redirect_to root_path
      end
    end

    def user_params
      params.require(:user).permit(:user_image, :name, :email, :introduction, :is_private)
    end
end
