class CoursesController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course_form = CourseForm.new
  end

  def create
    @course_form = CourseForm.new(course_params)
    if @course_form.save
      redirect_to user_path(current_user)
    else
      render "courses/errors"
    end
  end

  def edit
    @course = current_user.courses.find(params[:id])
    @course_form = CourseForm.new(course: @course)
  end

  def update
    @course = current_user.courses.find(params[:id])
    @course_form = CourseForm.new(course_params, course: @course)
    if @course_form.update
      redirect_to user_path(current_user)
    else
      render "courses/errors"
    end
  end

  def destroy
    @course = current_user.courses.find(params[:id])
    @course.destroy
    redirect_to user_path(current_user)
  end

  def record
    @course = Course.find(params[:id])
    @course.is_recorded = true
    @course.save
    redirect_to user_course_path(current_user, @course)
  end

  private
    def course_params
      params.require(:course).permit(:user_id, :name, :introduction, :vehicle_id, :avoid_highways, :avoid_tolls, :departure, :spots)
    end
end
