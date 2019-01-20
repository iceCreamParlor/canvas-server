class AddUserToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_reference :paintings, :user, foreign_key: true
  end
end
