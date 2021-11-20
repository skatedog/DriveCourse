class PlacesController < ApplicationController
  before_action :authenticate_user!

  def index
    @places = current_user.places
    @place = Place.new
  end

  def create
    @place = current_user.places.new(place_params)
    if @place.save
    else
      render :index
    end
  end

  def destroy
    @place = Place.find(params[:id])
    redirect_to places_path if @place.user != current_user
    @place.destroy
  end

  private
    def place_params
      params.require(:place).permit(:name, :latitude, :longitude, :address)
    end
end
