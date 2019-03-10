class Option < ApplicationRecord
  belongs_to :painting, optional: true
  
  default_scope -> {order(:position)}

end
