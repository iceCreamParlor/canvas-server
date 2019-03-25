class Painting < ApplicationRecord
  mount_uploaders :images, ImageUploader
  mount_uploader :thumbnail, ImageUploader

  belongs_to :color
  belongs_to :category
  belongs_to :user
  belongs_to :web_magazine, optional: true

  has_many :likes, dependent: :destroy
  has_many :auctions, dependent: :destroy
  has_many :painting_comments, dependent: :destroy
  has_many :options, dependent: :nullify

  scope :only_commerce, -> {where(status: "commerce")}
  scope :except_commerce, -> {where.not(status: "commerce")}
  scope :order_price, -> {order("price asc")}
  
  enum :status => ["sale", "sold", "not_sale", "auction", "commerce"]

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

  def generate_options
    
    Option.create painting: self, title: "10호", position: 0, price: 0
    Option.create painting: self, title: "13호", position: 1, price: 10000
    Option.create painting: self, title: "16호", position: 2, price: 20000
    Option.create painting: self, title: "20호", position: 3, price: 30000
    
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
