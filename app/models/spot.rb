class Spot < ApplicationRecord
  belongs_to :places
  belongs_to :course
end
