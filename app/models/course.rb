class Course < ApplicationRecord
  has_many :spots, dependent: :destroy
  has_many :course_likes, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle, optional: true

  scope :recent, -> { order(created_at: :desc) }
  scope :only_recorded, -> { where(is_recorded: true) }
  scope :with_details, -> { eager_load(:user).preload(:course_likes) }
  scope :with_spots, -> { preload(spots: [:genre, :user, :spot_likes]) }

  def self.search(search_params)
    keyword = search_params[:keyword]    # キーワード
    address = search_params[:address]    # 住所
    genre_id = search_params[:genre_id]  # ジャンル
    category = search_params[:category]  # 車orバイク
    use_for = search_params[:use_for]    # 用途
    sort_by = search_params[:sort_by]    # 並び順

    result =
      joins(:user).where(users: { is_private: false }).
      where(is_recorded: true).
      where("courses.name LIKE ?", "%#{keyword}%"). # キーワード
      yield_self do |courses| # 住所,ジャンル
        if address == "" && genre_id == ""
          courses
        elsif genre_id == ""
          courses.joins(:spots).where("spots.address LIKE ?", "%#{address}%")
        elsif address == ""
          courses.joins(:spots).where(spots: { genre_id: genre_id })
        else
          courses.joins(:spots).where("spots.address LIKE ?", "%#{address}%").
          where(spots: { genre_id: genre_id })
        end
      end.
      yield_self do |courses| # 車orバイク,用途
        if category == "none"
          courses
        else
          if use_for.length == 1
            courses.joins(:vehicle).where(vehicles: { category: category })
          else
            courses.joins(:vehicle).where(vehicles: { use_for: use_for, category: category })
          end
        end
      end.
      select('courses.*').
      yield_self do |courses| # 並び順
        if sort_by == "new"
          courses.order(created_at: :desc)
        else
          courses.sort do |a, b|
            b.course_likes.size <=>
            a.course_likes.size
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
    course_likes.pluck(:user_id).include?(user.id)
  end
end
