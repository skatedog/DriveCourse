class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :user_image, UserImageUploader

  has_many :vehicles, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :course_likes, dependent: :destroy
  has_many :like_courses, through: :course_likes, source: :course
  has_many :spots, through: :courses
  has_many :spot_likes, dependent: :destroy
  has_many :like_spots, through: :spot_likes, source: :spot

  validates :name, presence: true, length: { maximum: 50 }
  validates :is_private, inclusion: { in: [true, false] }

  def import_spot(spot)
    hash = spot.slice(:name, :latitude, :longitude, :address)
    self.places.create(hash)
  end

  def import_course(course)
    ActiveRecord::Base.transaction do
      hash = course.slice(:name, :introduction, :avoid_highways, :avoid_tolls, :departure)
      array = course.spots.map { |spot| spot.slice(:genre_id, :sort_number, :name, :latitude, :longitude, :address) }
      course = self.courses.create!(hash)
      course.spots.create!(array)
    end
  end
end
