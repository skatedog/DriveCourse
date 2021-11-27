module SpotsHelper
  def google_map_spot_link(spot)
    "https://www.google.co.jp/maps/dir/" + "/#{spot.latitude},#{spot.longitude}"
  end
end
