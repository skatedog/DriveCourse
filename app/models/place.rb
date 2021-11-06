class Place < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  validates :user_id, presence: true
  validates :genre_id, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
  validates :is_protected, presence: true
end
