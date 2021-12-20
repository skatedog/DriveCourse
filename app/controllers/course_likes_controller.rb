class CourseLikesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    @course.course_likes.create(user: current_user)
  end

  def destroy
    @course = Course.find(params[:course_id])
    @course.course_likes.find_by(user: current_user).destroy
  end
end
