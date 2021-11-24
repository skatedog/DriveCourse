class CourseForm
  include ActiveModel::Model
  attr_accessor :user_id, :vehicle_id, :name, :introduction, :is_recorded,
                :avoid_highways, :avoid_tolls, :departure, :spots, :course

  validates :user_id, presence: true
  validates :name, presence: true
  validates :avoid_highways, inclusion: { in: ["true", "false"] }
  validates :avoid_tolls, inclusion: { in: ["true", "false"] }
  validate :check_spots
  validate :check_departure

  delegate :persisted?, to: :course # courseクラスのpersisted?(保存済みか確認する)メソッドを使えるようにする。

  def initialize(attributes = nil, course: Course.new)
    @course = course
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    ActiveRecord::Base.transaction do
      return unless self.valid?
      spots_array = JSON.parse(spots)
      course = Course.new(user_id: user_id, name: name, introduction: introduction,
                          vehicle_id: vehicle_id, avoid_highways: avoid_highways,
                          avoid_tolls: avoid_tolls, departure: departure)
      course.save!
      course.spots.create!(spots_array)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def update
    ActiveRecord::Base.transaction do
      return unless self.valid?
      course.update!(name: name, introduction: introduction, vehicle_id: vehicle_id, avoid_highways: avoid_highways, avoid_tolls: avoid_tolls, departure: departure)
      # コースにスポットがあるか確認し、無ければ保存する。
      spots_array = JSON.parse(spots)

      spots_array.each do |spot|
        course.spots.where(name: spot["name"]).first_or_create.update(spot)
      end
      # 不要なスポットを削除する。
      (course.spots.pluck(:name) - spots_array.pluck("name")).each do |name|
        course.spots.find_by(name: name).destroy
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def to_model
    @course
  end

  private
    def check_spots
      unless JSON.parse(spots).length.between?(2, 10)
        errors.add(:spots, "スポットは2～10か所で設定してください。")
      end
    end
    def check_departure
      if Time.zone.parse(departure) < Time.current
        errors.add(:departure, "出発日時は未来の日時を設定してください。")
      end
    end
    def default_attributes
      {
        user_id: course.user_id,
        vehicle_id: course.vehicle_id,
        name: course.name,
        introduction: course.introduction,
        is_recorded: course.is_recorded,
        avoid_highways: course.avoid_highways,
        avoid_tolls: course.avoid_tolls,
        departure: course.departure,
      }
    end
end