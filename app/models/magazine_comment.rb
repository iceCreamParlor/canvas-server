class MagazineComment < ApplicationRecord
  belongs_to :user
  belongs_to :magazine
end
