class Place < ApplicationRecord
  after_validation :remove_unnecessary_error_messages

  belongs_to :user

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true

  def remove_unnecessary_error_messages
    self.errors.messages.delete(:latitude)
    self.errors.messages.delete(:longitude)
  end
end
