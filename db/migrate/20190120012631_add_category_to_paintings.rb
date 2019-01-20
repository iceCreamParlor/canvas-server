class AddCategoryToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_reference :paintings, :category, foreign_key: true
    add_reference :paintings, :color, foreign_key: true
  end
end
