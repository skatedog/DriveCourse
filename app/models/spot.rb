class Spot < ApplicationRecord
  belongs_to :place
  belongs_to :course
end
