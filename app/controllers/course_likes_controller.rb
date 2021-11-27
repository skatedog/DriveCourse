class CourseLikesController < ApplicationController
  def create
    @course = Course.find(params[:course_id])
    @course.course_likes.create(user_id: current_user.id)
  end

  def destroy
    @course = Course.find(params[:course_id])
    @course.course_likes.find_by(user_id: current_user.id).destroy
  end
end
