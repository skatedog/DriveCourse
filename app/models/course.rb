class Course < ApplicationRecord
  has_many :spots, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle, optional: true

  validates :user_id, presence: true
  validates :name, presence: true
  validates :is_protected, inclusion: { in: [true, false] }
  validates :avoid_highways, inclusion: { in: [true, false] }
  validates :avoid_tolls, inclusion: { in: [true, false] }

  def spots_update(new_spots)
    old_spot_names = self.spots.pluck(:name)
    new_spot_names = new_spots.pluck("name")
    new_spots.each do |spot|
      case spot["name"]
      when *(new_spot_names - old_spot_names)
        self.spots.create(spot)
      when *(new_spot_names & old_spot_names)
        self.spots.find_by(name: spot["name"]).update(spot)
      end
    end
    (old_spot_names - new_spot_names).each do |name|
      self.spots.find_by(name: name).destroy
    end
  end
end
