class SpotLikesController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    @spot.spot_likes.create(user_id: current_user.id)
  end
  def destroy
    @spot = Spot.find(params[:spot_id])
    @spot.spot_likes.find_by(user_id: params[:user_id]).destroy
  end
end
