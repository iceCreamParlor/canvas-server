class Message < ApplicationRecord
  enum message_type: ["question", "auction"]
end
