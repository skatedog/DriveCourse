class CourseForm
  include ActiveModel::Model
  attr_accessor :name, :introduction, :departure, :avoid_highways, :avoid_tolls, :spots

  delegate :persisted?, to: :post

  def initialize(course)
    @course = 
  end
  
  def save
    ActiveRecord::Base.transaction do
      tags = set_tag_list.map{ |tag_name| Tag.where(name: tag_name).first_or_create }
      post.update!(title: title, content: content, tags: tags)
    end
  end

  def to_model
    post
  end

  private

  attr_reader :post

  def default_attributes
    {
      title: post.title,
      content: post.content,
      tags: post.tags.pluck(:name).join(",")
    }
  end

  def set_tag_list
    tag_names.split(",")
  end

end