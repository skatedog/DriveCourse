class Spot < ApplicationRecord
  has_many :spot_likes, dependent: :destroy
  belongs_to :course
  belongs_to :genre, optional: true
  has_one :user, through: :course
  mount_uploaders :spot_images, SpotImagesUploader

  validates :course_id, presence: true
  validates :sort_number, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
  validates :stopover, presence: true

  def self.search(search_params)
    keyword = search_params[:keyword]
    address = search_params[:address]
    genre_id = search_params[:genre_id]
    category = search_params[:category]
    sort_by = search_params[:sort_by]
    use_for = search_params[:use_for]

    result =
    self.joins(:user).where(users: { is_private: false })
        .left_joins(course: :vehicle).where(courses: { is_recorded: true })
        .where("spots.name LIKE ?", "%#{keyword}%").where("spots.address LIKE ?", "%#{address}%")
        .yield_self do |spots|
          if genre_id == ""
            p spots
            spots
          else
            spots.where(spots: { genre_id: genre_id })
          end
        end
        .yield_self do |spots|
          if category == "none"
            p "bbbb"
            spots
          else
            spots.where(vehicles: { use_for: use_for, category: category })
          end
        end
        .select('spots.*')
        .yield_self do |spots|
          if sort_by == "new"
            spots.order(created_at: :desc)
          else
            p "sortaaaaaaaaaaa"
            spots.eager_load(:spot_likes).sort do |a, b|
              b.spot_likes.size <=>
              a.spot_likes.size
            end
          end
        end

    if sort_by == "new"
      p "new"
      result
    else
      Kaminari.paginate_array(result)
    end
  end
  def liked_by?(user)
    self.spot_likes.where(user_id: user.id).exists?
  end
end
