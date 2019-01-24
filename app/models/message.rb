class Message < ApplicationRecord
  enum message_type: ["question", "auction"]
  belongs_to :seller, class_name:  "User"
  belongs_to :buyer, class_name:  "User"
  belongs_to :painting, optional: true
end
