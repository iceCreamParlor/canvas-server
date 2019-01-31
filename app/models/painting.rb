class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader
  belongs_to :color
  belongs_to :category
  belongs_to :user
  
  #infinite scroll에서 한번에 10개의 게시물만 표시해 준다.
  PER_PAGE = 9
end
