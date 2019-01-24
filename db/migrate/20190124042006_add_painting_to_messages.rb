class AddPaintingToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :painting, foreign_key: true
  end
end
