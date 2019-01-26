class Magazine < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
  belongs_to :user
  has_many :magazine_comments
end
