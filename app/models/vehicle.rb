class Vehicle < ApplicationRecord
  enum use_for: { town: 0, touring: 1, sports: 2 }
  enum category: { car: 0, motorcycle: 1 }
  mount_uploaders :vehicle_images, VehicleImagesUploader

  belongs_to :user
  has_many :courses

  validates :user_id, presence: true
  validates :use_for, presence: true
  validates :category, presence: true
  validates :maker, presence: true
  validates :displacement, presence: true
  validates :name, presence: true
end
