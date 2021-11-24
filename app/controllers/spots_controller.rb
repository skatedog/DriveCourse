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

  private
    def spot_params
      params.require(:spot).permit(:genre_id, :name, :introduction, spot_images: [])
    end
end