# サンプルUser
User.create!(
  name: "hoge",
  email: "hoge@example.com",
  password: "password",
  password_confirmation: "password"
)

# サンプルGenre
Genre.create!([
  { name: "道の駅"},
  { name: "飲食店"},
  { name: "温泉"}
])

# サンプルPlace
Place.create!([
  { user_id: 1, name: "渋谷駅", latitude: 35.6580382, longitude: 139.6994471, address:"東京都渋谷区" },
  { user_id: 1, name: "新宿駅", latitude: 35.6895458, longitude: 139.7009638, address:"東京都新宿区新宿３丁目３８−１" },
  { user_id: 1, name: "池袋駅", latitude: 35.7295071, longitude: 139.7087114, address:"東京都豊島区南池袋１丁目" },
])

# サンプルCourse
20.times do
  Course.create!(user_id: 1, name: "サンプルCourse", departure: Time.current, is_recorded: true).spots.create!([
    { course_id: 1, sort_number: 0, name: "渋谷駅", latitude: 35.6580382, longitude: 139.6994471, address:"東京都渋谷区" },
    { course_id: 1, sort_number: 1, name: "新宿駅", latitude: 35.6895458, longitude: 139.7009638, address:"東京都新宿区新宿３丁目３８−１" },
    { course_id: 1, sort_number: 2, name: "池袋駅", latitude: 35.7295071, longitude: 139.7087114, address:"東京都豊島区南池袋１丁目" },
  ])
end