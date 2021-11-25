require "csv"

# サンプルGenre
CSV.foreach("db/seeds/csv/genre.csv", headers: true) do |genre|
  Genre.create!(
    id: genre["id"],
    name: genre["name"]
  )
end

# サンプルUser
i = 0
CSV.foreach("db/seeds/csv/user.csv", headers: true) do |user|
  User.create!(
    id: user["id"],
    name: user["name"],
    email: "user#{i}@example.com",
    is_private: false,
    password: "password",
    password_confirmation: "password"
  )
  i += 1
end

CSV.foreach("db/seeds/csv/course.csv", headers: true) do |course|
  Course.create!(
    id: course["id"],
    user_id: course["user_id"],
    name: course["name"],
    introduction: course["introduction"],
    is_recorded: true,
    departure: Time.current,
  )
end

CSV.foreach("db/seeds/csv/spot.csv", headers: true) do |spot|
  Spot.create!(
    course_id: spot["course_id"],
    genre_id: spot["genre_id"],
    sort_number: spot["sort_number"],
    name: spot["name"],
    introduction: spot["introduction"],
    latitude: spot["latitude"],
    longitude: spot["longitude"],
    address: spot["address"],
    spot_images: [File.open("./public/images/course/#{spot["course_id"]}/#{spot["sort_number"]}.jpg")],
  )
end