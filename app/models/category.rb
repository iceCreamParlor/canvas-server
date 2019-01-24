class Category < ApplicationRecord
  has_many :paintings

  def filter_paintings(user: ) 
    self.paintings.where(user_id: user.id)
  end
    
end
