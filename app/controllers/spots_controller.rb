class SpotsController < ApplicationController
  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      redirect_to course_path(@spot.course)
    else
      render :edit
    end
  end

  def import
    spot = Spot.find(params[:id])
    redirect_to user_path(current_user) if spot.course.user.is_private
    current_user.import_spot(spot)
    redirect_back(fallback_location: root_path)
  end

  private
    def spot_params
      params.require(:spot).permit(:genre_id, :name, :introduction, spot_images: [])
    end
end