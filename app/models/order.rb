class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items

  enum state: %i[cart direct complete cancel request_cancel]
  enum shipment_state: %i[ready shipping shipped]

  before_save :generate_order_number, only: [:create]

  default_scope -> { order('created_at desc') }
  scope :carts, -> { where(state: :cart) }
  scope :request_cancels, -> { where(state: :request_cancel) }
  scope :cancels, -> { where(state: :cancel) }
  scope :finished, -> { where(state: :complete) }
  scope :completes, -> { where(state: :complete) }
  scope :shippeds, -> { where(shipment_state: :shipped) }
  scope :not_shippeds, -> { where.not(shipment_state: :shipped) }

  STATES = { cart: '장바구니', direct: '바로주문', complete: '주문완료', request_cancel: '취소 요청', cancel: '주문 취소' }.freeze
  SHIPMENT_STATES = { ready: '배송준비중', shipping: '배송중', shipped: '배송완료' }.freeze

  def state_kr
    STATES[state.to_sym]
  end

  def not_cancel_or_request_cancel
    !(cancel? || request_cancel?)
  end

  def shipment_state_kr
    SHIPMENT_STATES[shipment_state.to_sym]
  end

  def full_address
    "#{zipcode} #{address1} #{address2}"
  end

  def to_param
    order_number
  end

  def find_past_line_item option_id, painting_id
    past_line_item = self.line_items.find_by(option_id: option_id, painting_id: painting_id)
    return past_line_item
  end

  def get_payment_amount

    item_total = 0

    line_items.each do |item|
      item_total += (item.amount.to_i)
    end

    shipment_fee = line_items.present? ? 100 : 0

    item_discount = 0

    payment_amount = item_total + shipment_fee - item_discount

    [payment_amount, item_total, shipment_fee, item_discount]
  end

  private

  def generate_order_number
    self.order_number = SecureRandom.hex(6).upcase if new_record?
  end
end
