class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader
  belongs_to :color
  belongs_to :category

  belongs_to :user
  has_many :likes
  has_many :auctions
  has_many :painting_comments

  # scope :only_sale, -> {where(status: "sale")}
  
  enum :status => ["sale", "sold", "not_sale"]

  scope :exclude_images, ->  { select( Painting.attribute_names - ['images'] ) }

  def self.options_for_status
    Painting.statuses.map{ |p| [ I18n.t("painting.#{p[0]}"), p[0]] }
  end

  def translate_status
    case self.status
    when "normal"
      "판매"
    when "auction"
      "경매중"
    when "sold"
      "판매 완료"
    when "not_sale"
      "판매 안함"
    end
  end

  def user_likes? user
    painting = Like.find_by(user_id: user.id, painting_id: self.id)
    if painting.present?
      return true
    end
    return false
  end

  #infinite scroll에서 한번에 10개의 게시물만 표시해 준다.
  PER_PAGE = 9
end
