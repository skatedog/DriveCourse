class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_my_vehicle, only: [:edit, :update, :destroy]

  def new
    @vehicle = current_user.vehicles.new(category: params[:category])
  end

  def create
    @vehicle = current_user.vehicles.new(vehicle_params)
    if @vehicle.save
      redirect_to current_user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to current_user
  end

  private
    def set_my_vehicle
      @vehicle = current_user.vehicles.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:use_for, :category, :maker, :displacement, :name, :introduction, vehicle_images: [])
    end
end
