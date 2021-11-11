class SpotsController < ApplicationController
  def create
    @course = current_user.courses.find(params[:course_id])
    @spot = @course.add_spot(params[:index].to_i, params[:place_id].to_i)
  end

  def destroy
    @course = current_user.courses.find(params[:course_id])
    @old_index = @course.remove_spot(params[:id].to_i)
  end
end