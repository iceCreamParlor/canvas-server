class LineItemsController < ApplicationController

  def update
    line_item = LineItem.find params[:id]
    # params[:line_item][:amount] = (line_item_params[:quantity].to_i * line_item.painting.price)

    if line_item.update line_item_params
      @line_item_updated = true
    else
      @line_item_updated = false
    end
    
    respond_to do |format|
      format.js
    end

    # redirect_to cart_orders_path, notice: "성공적으로 변경했습니다."
  end

  def destroy
    line_item = LineItem.find params[:id]
    line_item.destroy
    redirect_to cart_orders_path, notice: "성공적으로 삭제했습니다."
  end

  def add_to_cart
    cart = get_cart
    @flag = false
    painting = Painting.find(params[:line_item][:painting_id])

    if painting
      params["line_item"].reject!{|_, v| v.empty?}
      last_created_line_item = cart.find_past_line_item(params["line_item"]["option_id"], params["line_item"]["painting_id"])

      if last_created_line_item.present?
        # 카트에 이미 해당하는 같은 그림과 옵션이 있을 경우, 
        # 존재하는 기록에 수량과 가격만 update 시킨다.
        past_quantity = last_created_line_item.quantity.to_i
        past_amount = last_created_line_item.amount.to_i
        last_created_line_item.update(
            state: "not_cancel",
            amount: (last_created_line_item.painting.price.to_i + last_created_line_item.option.price.to_i ) * params["line_item"]["quantity"].to_i + past_amount, 
            quantity: past_quantity + params["line_item"]["quantity"].to_i
        )
          
        @flag = true
      else
        # 신규 등록일 경우, LineItem 을 추가한다.
        if cart.line_items.create!(line_item_params)
          (last_created_line_item = cart.line_items.first).update(
            state: "not_cancel", 
            amount: (last_created_line_item.painting.price.to_i + last_created_line_item.option.price.to_i ) * params["line_item"]["quantity"].to_i

          )
          @flag = true
        end
      end
    end

    respond_to do |format|
      format.js
    end
  end

  def direct
    order = direct_order
    painting = Painting.find(params[:line_item][:painting_id])
    if painting
      params["line_item"]["options_attributes"].reject!{|_, v| v["option_id"].empty? || v["quantity"].empty?}
      if order.line_items.create!(line_item_params)
        (last_created_line_item = order.line_items.first).update amount: last_created_line_item.option_groups.sum(:quantity)*painting.price
        @flag = true
      end
    end
    redirect_to pay_order_path(order)
  end

  private
  def line_item_params
    params.require(:line_item).permit(:order_id, :amount, :state, :painting_id, :option_id, :quantity)
  end
end
