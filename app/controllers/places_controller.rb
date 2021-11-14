class PlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :get_my_place, except: [:index, :new, :create]

  def index
    @places = current_user.places
  end

  def show
  end

  def new
    @place = current_user.places.new
  end

  def create
    @place = current_user.places.new(place_params)
    if @place.save
      redirect_to place_path(@place)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to place_path(@place)
    else
      render :edit
    end
  end

  def destroy
    @place.destroy
    redirect_to places_path
  end

  private
    def get_my_place
      @place = Place.find(params[:id])
      redirect_to places_path if @place.user != current_user
    end
    def place_params
      params.require(:place).permit(:name, :latitude, :longitude, :address)
    end
end
