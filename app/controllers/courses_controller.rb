class CoursesController < ApplicationController
  def top
  end

  def index
    @courses = current_user.courses
  end

  def show
    @course = current_user.courses.find(params[:id])
  end

  def new
    @course = current_user.courses.new
  end

  def create
    @course = current_user.courses.new(course_params)
    @course.save
    place_ids = [
      course_place_params[:origin],
      course_place_params[:waypoint],
      course_place_params[:destination],
    ]
    @course.create_sopts_by(place_ids)
    redirect_to user_course_path(current_user, @course)
  end

  def edit
    @course = current_user.courses.find(params[:id])
  end

  def update
    @course = current_user.courses.find(params[:id])
    ids = params[:ids]
    ids.each_with_index do |id, i|
      @course.spots.find(id).update(sort_number: i)
    end
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy
    redirect_to user_courses_path(current_user)
  end

  private
    def course_params
      params.require(:course).permit(:vehicle_id, :name, :introduction, :is_protected)
    end
    def course_place_params
      params.require(:course).permit(:origin, :waypoint, :destination)
    end
end
