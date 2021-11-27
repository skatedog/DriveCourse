module CoursesHelper
  def google_map_course_link(course)
    course.spots.inject("https://www.google.co.jp/maps/dir/") do |url, spot|
      url += "/#{spot.latitude},#{spot.longitude}"
    end
  end
end