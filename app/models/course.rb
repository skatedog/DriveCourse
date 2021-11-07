class Course < ApplicationRecord
  has_many :spots, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle
end
