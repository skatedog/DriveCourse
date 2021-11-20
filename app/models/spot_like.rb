class SpotLike < ApplicationRecord
  belongs_to :user
  belongs_to :spot
end
