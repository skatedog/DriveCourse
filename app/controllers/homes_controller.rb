class HomesController < ApplicationController
  def top
    case search_params[:search_for]
    when "spot"
      @spots = Spot.search(search_params).page(params[:page])
    when "course"
      @courses = Course.search(search_params).page(params[:page])
    else
      @spots = Spot.all
    end
  end

  private
    def search_params
      params.permit(:keyword, :address, :genre_id, :category, :sort_by, :search_for, use_for:[])
    end
end
