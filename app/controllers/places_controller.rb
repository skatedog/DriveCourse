class PlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, except: [:index, :show]

  def index
    places = User.find(params[:user_id]).places
    if params[:user_id].to_i == current_user.id
      @places = places
    else
      @places = places.where(is_protected: false)
    end
  end

  def show
    place = User.find(params[:user_id]).places.find(params[:id])
    if (place.user != current_user) && place.is_protected
      redirect_to user_places_path(current_user)
    end
    @place = place
  end

  def new
    @place = current_user.places.new
  end

  def create
    @place = current_user.places.new(place_params)
    if @place.save
      redirect_to user_place_path(current_user, @place)
    else
      render :new
    end
  end

  def edit
    @place = current_user.places.find(params[:id])
  end

  def update
    @place = current_user.places.find(params[:id])
    if @place.update(place_params)
      redirect_to user_place_path(current_user, @place)
    else
      render :edit
    end
  end

  def destroy
    current_user.places.find(params[:id]).destroy
    redirect_to user_places_path(current_user)
  end

  private
    def place_params
      params.require(:place).permit(:genre_id, :is_protected, :name, :introduction, :address, :latitude, :longitude)
    end
end
