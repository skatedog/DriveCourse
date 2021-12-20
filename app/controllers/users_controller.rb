class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_and_set_current_user, except: :show

  def show
    @user = User.find(params[:id])
    if @user == current_user
      @courses = @user.courses.with_details.recent.page(params[:page])
    else
      redirect_to root_path if @user.is_private?
      @courses = @user.courses.with_details.recent.only_recorded.page(params[:page])
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
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
      @spots = @user.like_spots.with_details.recent.page(params[:page])
    when "course"
      @courses = @user.like_courses.with_details.recent.page(params[:page])
    end
  end

  private

  def ensure_and_set_current_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end

  def user_params
    params.require(:user).permit(:user_image, :name, :email, :introduction, :is_private)
  end
end
