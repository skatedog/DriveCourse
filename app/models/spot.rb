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

  scope :recent, -> { order(created_at: :desc) }
  scope :with_details, -> { eager_load(:user, :genre, course: :user).preload(:spot_likes) }

  def self.search(search_params)
    keyword = search_params[:keyword]    # キーワード
    address = search_params[:address]    # 住所
    genre_id = search_params[:genre_id]  # ジャンル
    category = search_params[:category]  # 車orバイク
    use_for = search_params[:use_for]    # 用途
    sort_by = search_params[:sort_by]    # 並び順

    result =
      joins(:user).where(users: { is_private: false }).
      left_joins(course: :vehicle).where(courses: { is_recorded: true }).
      where("spots.name LIKE ?", "%#{keyword}%"). # キーワード
      where("spots.address LIKE ?", "%#{address}%"). # 住所
      yield_self do |spots| # ジャンル
        if genre_id == ""
          spots
        else
          spots.where(spots: { genre_id: genre_id })
        end
      end.
      yield_self do |spots| # 車orバイク,用途
        if category == "none"
          spots
        else
          if use_for.length == 1
            spots.where(courses: { vehicles: { category: category } } )
          else
            spots.where(courses: { vehicles: { use_for: use_for, category: category } } )
          end
        end
      end.
      select('spots.*').
      yield_self do |spots| # 並び順
        if sort_by == "new"
          spots.order(created_at: :desc)
        else
          spots.sort do |a, b|
            b.spot_likes.size <=>
            a.spot_likes.size
          end
        end
      end
    if sort_by == "new"
      result
    else
      Kaminari.paginate_array(result)
    end
  end

  def liked_by?(user)
    spot_likes.pluck(:user_id).include?(user.id)
  end
end
