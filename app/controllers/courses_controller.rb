class CoursesController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_my_course, only: [:edit, :update, :destroy, :record]

  def show
    @course = Course.with_details.with_spots.find(params[:id])
    if !@course.is_recorded? || ((@course.user != current_user) && @course.user.is_private?)
      redirect_to current_user
    end
  end

  def new
    @course_form = CourseForm.new
  end

  def create
    @course_form = CourseForm.new(course_params)
    if @course_form.save
      redirect_to current_user
    else
      render "courses/errors"
    end
  end

  def edit
    redirect_to current_user if @course.is_recorded?
    @course_form = CourseForm.new(course: @course)
  end

  def update
    @course_form = CourseForm.new(course_params, course: @course)
    if @course_form.update
      redirect_to current_user
    else
      render "courses/errors"
    end
  end

  def destroy
    @course.destroy
    redirect_back(fallback_location: root_path)
  end

  def record
    @course.update(is_recorded: true)
    redirect_to course_path(@course)
  end

  def import
    course = Course.find(params[:id])
    if course.user.is_private? || !course.is_recorded?
      redirect_to current_user
    else
      current_user.import_course(course)
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_my_course
    @course = current_user.courses.find(params[:id])
  end

  def course_params
    params.require(:course).permit(
      :user_id, :name, :introduction, :vehicle_id, :avoid_highways,
      :avoid_tolls, :departure, :spots
    )
  end
end
