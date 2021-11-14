class Spot < ApplicationRecord
  belongs_to :course
  belongs_to :genre, optional: true

  validates :course_id, presence: true
  validates :sort_number, presence: true
  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
  validates :stopover, presence: true
end
