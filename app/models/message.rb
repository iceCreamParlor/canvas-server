class Message < ApplicationRecord
  enum message_type: ["question", "auction"]
  belongs_to :painting
end
