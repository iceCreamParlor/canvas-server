class MessagesController < ApplicationController
  def create
    
    buyer_id = params[:sender_id]
    seller_id = params[:seller_id]
    content = params[:content]
    Message.create(buyer_id: buyer_id, seller_id: seller_id, content: content, message_type: 'question')
    
  end
end
