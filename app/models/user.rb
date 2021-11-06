class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :user_image, UserImageUploader

  has_many :vehicles, dependent: :destroy
  has_many :places, dependent: :destroy

  validates :name, presence: true
end
