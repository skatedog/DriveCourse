class HomesController < ApplicationController
  def top
    redirect_to current_user if user_signed_in?
  end

  def search
    case search_params[:search_for]
    when "spot"
      @spots = Spot.eager_load(:genre, :user, course: :user).preload(:spot_likes).search(search_params).page(params[:page])
    when "course"
      @courses = Course.eager_load(:user).preload(:course_likes).search(search_params).page(params[:page])
    end
  end

  private

  def search_params
    params.permit(:keyword, :address, :genre_id, :category, :sort_by, :search_for, use_for: [])
  end
end
