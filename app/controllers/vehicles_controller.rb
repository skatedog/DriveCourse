class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, except: :show

  def show
    @vehicle = current_user.vehicles.find(params[:id])
  end

  def new
    @vehicle = current_user.vehicles.new
    @vehicle.category = params[:category]
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
    @vehicle = current_user.vehicles.find(params[:id])
  end

  def update
    @vehicle = current_user.vehicles.find(params[:id])
    if @vehicle.update(vehicle_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  def destroy
    current_user.vehicles.find(params[:id]).destroy
      redirect_to current_user
  end

  private
    def vehicle_params
      params.require(:vehicle).permit(:use_for, :category, :maker, :displacement, :name, :introduction, vehicle_images: [])
    end
end
