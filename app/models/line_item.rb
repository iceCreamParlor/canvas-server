class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :option
  belongs_to :painting

  scope :cancels, -> { where(state: :cancel) }
  scope :not_cancels, -> { where(state: :not_cancel )} #일단 nil로

  before_destroy :nullify_option

  default_scope -> {order("line_items.created_at desc")}

  STATES = { not_cancel: '주문 완료', cancel: '주문 취소', request_cancel: '취소 요청' }.freeze
  
  enum state: [:not_cancel, :cancel_request, :cancel]
  

  def state_kr
    STATES[state.to_sym]
  end

  def nullify_option
    # 삭제 할 때 Foreign key 로 묶여 있던 옵션들을 삭제한다
    self.update(option: nil)
  end

end
