class MessagesController < ApplicationController

  before_action :authenticate_user!, only: [:index]

  def index
    @messages = current_user.arrived_messages
    @messages_json = @messages.to_json
    if @is_mobile
      render 'mobile_index.html.erb'
    else
      render 'index.html.erb'
    end
  end
  def create
    
    buyer_id = params[:sender_id]
    seller_id = params[:seller_id]
    content = params[:content]
    painting_id = params[:painting_id]

    if painting_id.present?
      Message.create!(buyer_id: buyer_id, seller_id: seller_id, painting_id: painting_id, content: content, message_type: 'question')
    else
      Message.create(buyer_id: buyer_id, seller_id: seller_id, content: content, message_type: 'question')
    end
    
  end
  def load_message
    @message = Message.find(params[:id])
    @sender = User.find(@message.buyer_id)
    if @message.painting_id.present?
      @painting = Painting.find(@message.painting_id)
    end
  end
end
