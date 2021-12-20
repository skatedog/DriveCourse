class SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_spot, except: :import

  def edit
  end

  def update
    if @spot.update(spot_params)
      redirect_to @spot.course
    else
      render :edit
    end
  end

  def import
    spot = Spot.find(params[:id])
    if spot.user.is_private? || !spot.course.is_recorded?
      redirect_to current_user
    else
      current_user.import_spot(spot)
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_my_spot
    @spot = current_user.spots.find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(:genre_id, :name, :introduction, spot_images: [])
  end
end
