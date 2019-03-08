class Auction < ApplicationRecord
  belongs_to :user
  belongs_to :painting
  has_many :auction_candidates, dependent: :destroy
end
