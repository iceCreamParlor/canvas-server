class AddWebMagazineToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_reference :paintings, :web_magazine, foreign_key: true
  end
end
