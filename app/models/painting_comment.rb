class PaintingComment < ApplicationRecord
  belongs_to :user
  belongs_to :painting
end
