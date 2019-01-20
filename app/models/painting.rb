class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader
end
