class WebMagazine < ApplicationRecord
  mount_uploader :image, MagazineUploader
  has_many :paintings
  has_many :interviews
  enum position: [:left, :right]
end
