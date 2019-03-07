class Magazine < ApplicationRecord
  mount_uploader :thumbnail, ImageUploader
  belongs_to :user
  has_many :magazine_comments, dependent: :destroy
  enum priority: ["normal", "main", "head"]
  enum magazine_type: ["artist", "painting"]
end
