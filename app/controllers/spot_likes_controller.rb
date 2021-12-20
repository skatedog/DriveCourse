class SpotLikesController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    @spot.spot_likes.create(user: current_user)
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    @spot.spot_likes.find_by(user: current_user).destroy
  end
end
