class PlacesController < ApplicationController
  before_action :authenticate_user!

  def index
    @place = Place.new
    @places = current_user.places
  end

  def create
    @place = current_user.places.new(place_params)
    unless @place.save
      render "places/errors"
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
