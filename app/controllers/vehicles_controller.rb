class VehiclesController < ApplicationController
  def show
    @vehicle = current_user.vehicles.find(params[:id])
  end

  def new
    @vehicle = current_user.vehicles.new
  end

  def create
    @vehicle = current_user.vehicles.new(vehicle_params)
    p @vehicle
    if @vehicle.save
      redirect_to user_vehicle_path(@vehicle.user, @vehicle)
    else
      render :new
    end
  end

  def edit
    @vehicle = current_user.vehicles.find(params[:id])
  end

  def update
    @vehicle = current_user.vehicles.find(params[:id])
    if @vehicle.update(vehicle_params)
      redirect_to user_vehicle_path(@vehicle.user, @vehicle)
    else
      render :edit
    end
  end

  def destroy
    current_user.vehicles.find(params[:id]).destroy
    redirect_to user_path(current_user)
  end

  private
  def vehicle_params
    params.require(:vehicle).permit(:use_for, :category, :maker, :displacement, :name, :introduction, vehicle_images: [])
  end
end
