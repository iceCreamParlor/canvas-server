class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader
  belongs_to :color
  belongs_to :category
  belongs_to :user
  
end
