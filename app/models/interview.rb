class Interview < ApplicationRecord
  belongs_to :web_magazine
  enum position: [:left, :right]
end
