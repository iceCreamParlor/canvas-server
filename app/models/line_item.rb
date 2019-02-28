class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :option
  belongs_to :painting

  scope :cancels, -> { where(state: :cancel) }
  scope :not_cancels, -> { where(state: :not_cancel )} #일단 nil로

  before_destroy :nullify_option

  default_scope -> {order("line_items.created_at desc")}

  enum state: [:not_cancel, :cancel_request, :cancel]
  
  def nullify_option
    self.update(option: nil)
  end

end
