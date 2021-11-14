class CoursesController < ApplicationController
  before_action :authenticate_user!
  def top
  end

  def index
    @courses = User.find(params[:user_id]).courses
  end

  def show
    @course = User.find(params[:user_id]).courses.find(params[:id])
  end

  def new
    @course = current_user.courses.new
  end

  def create
    @course = current_user.courses.create(course_params)
    @course.spots.create(spots_params)
    redirect_to user_course_path(current_user, @course)
  end

  def edit
    @course = current_user.courses.find(params[:id])
  end

  def update
    @course = current_user.courses.find(params[:id])
    @course.update(course_params)
    @course.spots_update(spots_params)
    redirect_to user_course_path(current_user, @course)
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy
    redirect_to user_courses_path(current_user)
  end

  private
    def course_params
      params.require(:course).permit(:name, :introduction, :avoid_highways, :avoid_tolls, :departure)
    end
    def spots_params
      JSON.parse(params.require(:course).permit(:spots)[:spots])
    end
    def course_place_params
      params.require(:course).permit(:origin, :waypoint, :destination)
    end
end
