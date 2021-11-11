class Course < ApplicationRecord
  has_many :spots, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle

  validates :user_id, presence: true
  validates :name, presence: true
  validates :is_protected, inclusion: { in: [true, false] }

  def create_sopts_by(place_ids)
    place_list = place_ids.map.with_index do |id, i|
     {
       place_id: id.to_i,
       sort_number: i,
       is_protected: self.is_protected,
     }
    end
    self.spots.create(place_list)
  end

  def add_spot(index, place_id)
    self.spots.each do |spot|
      if spot.sort_number >= index
        spot.update(sort_number: spot.sort_number + 1)
      end
    end
    self.spots.create(
      place_id: place_id,
      sort_number: index,
      is_protected: self.is_protected,
    )
  end

  def remove_spot(spot_id)
    p self.spots
    old_spot = self.spots.find(spot_id)
    index = old_spot.sort_number
    self.spots.each do |spot|
      if spot.sort_number > index
        spot.update(sort_number: spot.sort_number - 1)
      end
    end
    old_spot.destroy.sort_number
  end
end
