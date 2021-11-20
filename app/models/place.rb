class Place < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
end
