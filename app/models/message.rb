class Message < ApplicationRecord
  enum message_type: ["question", "auction"]
  belongs_to :sender, class_name:  "User"
  belongs_to :receiver, class_name:  "User"
  belongs_to :painting, optional: true

  belongs_to :original_msg, class_name: "Message", foreign_key: "original_msg_id", optional: true

  def find_parent_message
    # 메세지의 가장 최상위 노드 메세지를 찾아주는 함수
    if self.original_msg_id.nil?
      # original_msg_id 가 nil 인 경우 => 최초에 보내진 메세지(답장이 없는) 인 경우
      return self
    else
      # 부모 메세지가 있는 경우
      message = Message.find(self.original_msg_id)
      return message
    end
  end

  def find_children_messages
    if self.original_msg_id.present?
      return nil
    else
      messages = Message.where(original_msg_id: self.id)
      return messages
    end
  end
end
