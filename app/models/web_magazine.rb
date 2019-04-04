class WebMagazine < ApplicationRecord
  default_scope { order("NUMBER") }

  mount_uploader :image, MagazineUploader
  has_many :paintings
  has_many :interviews
  belongs_to :web_magazine_group
  enum position: [:left, :right]
end
