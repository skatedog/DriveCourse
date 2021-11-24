class Course < ApplicationRecord
  has_many :spots, dependent: :destroy
  has_many :course_likes, dependent: :destroy
  belongs_to :user
  belongs_to :vehicle, optional: true

  def self.search(search_params)
    keyword = search_params[:keyword]
    address = search_params[:address]
    genre_id = search_params[:genre_id]
    category = search_params[:category]
    sort_by = search_params[:sort_by]
    use_for = search_params[:use_for]

    result =
    self.joins(:user).where(users: { is_private: false })
        .where(is_recorded: true).where("courses.name LIKE ?", "%#{keyword}%")
        .yield_self do |courses|
          if address == "" && genre_id == ""
            courses
          elsif genre_id == ""
            courses.joins(:spots).where("spots.address LIKE ?", "%#{address}%")
          elsif address == ""
            courses.joins(:spots).where(spots: { genre_id: genre_id })
          else
            courses.joins(:spots).where("spots.address LIKE ?", "%#{address}%").where(spots: { genre_id: genre_id })
          end
        end
        .yield_self do |courses|
          if category == "none"
            courses
          else
            courses.joins(:vehicle).where(vehicles: { use_for: use_for, category: category })
          end
        end
        .select('courses.*')
        .yield_self do |courses|
          if sort_by == "new"
            courses.order(created_at: :desc)
          else
            courses.eager_load(:course_likes).sort do |a, b|
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
    self.course_likes.where(user_id: user.id).exists?
  end
end
