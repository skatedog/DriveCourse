class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :user_image, UserImageUploader

  has_many :vehicles, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :course_likes, dependent: :destroy
  has_many :spots, through: :courses
  has_many :spot_likes, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :is_private, inclusion: { in: [true, false] }
end
