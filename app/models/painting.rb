class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader
  belongs_to :color
  belongs_to :category
  belongs_to :user
  has_many :likes
  
  scope :exclude_images, ->  { select( Painting.attribute_names - ['images'] ) }

  def user_likes? user
    painting = Like.find_by(user_id: user.id, painting_id: self.id)
    if painting.present?
      return true
    end
    return false
  end

  #infinite scroll에서 한번에 10개의 게시물만 표시해 준다.
  PER_PAGE = 9
end
