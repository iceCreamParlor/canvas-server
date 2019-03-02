class OrdersController < ApplicationController
  
  include Iamport
  before_action :check_authorization
  before_action :load_cart, only: %i[cart pay]
  before_action :load_order, only: %i[pay paying show complete cancel canceling request_cancel]

  def show
    redirect_to paintings_path if @order.cart? || @order.direct? || (@order.user != current_user)
  end

  def cart
    # code
  end

  def pay
    redirect_to paintings_path if @order.nil? || !(@order.cart? || @order.direct?) || (@order.user != current_user)
  end

  def paying
    @order.update order_params
    @payment_amount = @order.get_payment_amount[0]
    # @order.save
  end

  def complete
    # 결제 후에 도달하게 되는 액션

    # amount_to_be_paid = query_amount_to_be_paid(payment_result.merchant_uid) 
    #결제되었어야 하는 금액 조회. 가맹점에서는 merchant_uid기준으로 관리
    # IF payment_result.status == 'paid' AND payment_result.amount == amount_to_be_paid
    #   success_post_process(payment_result)
    # ELSE IF payment_result.status == 'ready' AND payment.pay_method == 'vbank'
    #   vbank_number_assigned(payment_result)
    # ELSE
    #   fail_post_process(payment_result)

    if params[:imp_success] == 'true'
      code, iamport_response = iamport_payment(params[:imp_uid])
      status, paid_amount, imp_uid, merchant_uid = iamport_response.values_at('status', 'amount', 'imp_uid', 'merchant_uid')
      payment_amount = @order.get_payment_amount[0]

      # if code.zero? && status == 'paid' && paid_amount == payment_amount
      if code.zero? && status == 'paid'
        @order.update(
          uid: params[:imp_uid],
          state: :complete,
          shipment_state: :ready,
          completed_at: Time.now,
          payment_amount: payment_amount
        )
        flash[:notice] = '결제에 성공했습니다.'
        redirect_to order_path(@order)
      else
        flash[:notice] = '결제에 실패했습니다. 다시 시도해주세요.'
      end
    else
      flash[:notice] = '결제에 실패했습니다. 다시 시도해주세요.'
      redirect_to root_path
    end
  end

  def order_list
    @orders = current_user.orders.finished
  end

  def cancel_list
    @orders = current_user.orders.cancels.or(current_user.orders.request_cancel)
  end

  def empty_cart
    cart = get_cart
    cart.line_items.destroy_all
    redirect_to cart_orders_path
  end

  def cancel
    @line_item = LineItem.find(params[:line_item_id])
  end
  def request_cancel
    @order = Order.find(cancel_params[:id])
    @order.update(cancel_params.permit(:id, :state))
    redirect_to cancel_list_orders_path
  end
  # 부분 취소시 참고하면 좋을 꺼 같아요! 개꿀
  def canceling    
    
    line_item = LineItem.find(params[:line_item_id].to_i)
    total_cancel_amount = params[:amount].to_i
    uid = @order.uid
    code, message, response = iamport_cancel(uid, total_cancel_amount)
    # if code.zero? && response['cancel_amount'] == total_cancel_amount && response["imp_uid"] == @order.uid
    if code.zero? && response["imp_uid"] == @order.uid
      line_item.update(state: :cancel)
      if @order.line_items.not_cancels.empty?
        @order.update(state: :cancel)
        
      end
      
    else
      puts message
    end
    redirect_to order_list_orders_path
  end

  private

  def load_cart
    @order = get_cart
    @payment_amount = @order.get_payment_amount
  end
  

  def load_order
    @order = Order.find_by_order_number params[:order_number]
  end

  def order_params
    params.require(:order).permit(:state, :user_id, :name, :phone, :zipcode,
                                  :address1, :address2, :note, :payment_method, :uid, :payment_info, :item_total, :shipment_total,
                                  :shipment_state, :shipment_number, :order_number)
  end

  def cancel_params
    params.require(:order).permit!
  end

  def check_authorization
    if current_user

    else
      redirect_to paintings_path, notice: '로그인 해주세요'
    end
  end
end
