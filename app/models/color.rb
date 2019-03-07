class Color < ApplicationRecord
  has_many :paintings, dependent: :nullify
end
