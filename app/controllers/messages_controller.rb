class MessagesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_message, only: [:show]

  def index
    @messages_total = current_user.arrived_messages.order("created_at DESC")
    
    @messages = []
    
    @messages_total.each do |message|
      @messages << message.find_parent_message
    end
    @messages = @messages.uniq
    @messages_count = @messages.map{ |m| m.find_children_messages.count }
    @messages = @messages.map{ |m| m.find_children_messages.last }
    @messages = @messages.paginate(:page => params[:page], :per_page => Message::PER_PAGE)
    @messages_json = @messages.to_json
    
    if @is_mobile
      render 'mobile_index.html.erb'
    else
      # 데스크탑 / 노트북
      render 'index.html.erb'
    end
  end
  
  def show
  end

  def create
    
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    content = params[:content]
    painting_id = params[:painting_id]
    message_id = params[:message_id]

    if painting_id.present?
      if message_id.present?
        
        @message = Message.create!(sender_id: sender_id, receiver_id: receiver_id, painting_id: painting_id, content: content, original_msg_id: message_id, message_type: 'question')
      else
        @message = Message.create!(sender_id: sender_id, receiver_id: receiver_id, painting_id: painting_id, content: content, message_type: 'question')
      end
    else
      if message_id.present?
        @message = Message.create!(sender_id: sender_id, receiver_id: receiver_id, content: content, original_msg_id: message_id, message_type: 'question')
      else
        @message = Message.create!(sender_id: sender_id, receiver_id: receiver_id, content: content, message_type: 'question')
      end
    end
    UserMailer.delay.message_arrived_email(user: @message.receiver, message: @message)
  end
  def load_message

    @parent_message = Message.find(params[:id]).find_parent_message
    @sender = User.find(@parent_message.sender_id)
    @children_messages = @parent_message.find_children_messages
    @last_message = @children_messages.last
    # puts "!!!!"
    # puts @parent_message.id
    # puts @parent_message.painting_id
    if @parent_message.painting_id.present?
      @painting = Painting.find(@parent_message.painting_id)
    end
  end
end
