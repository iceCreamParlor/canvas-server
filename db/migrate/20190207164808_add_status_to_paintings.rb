class AddStatusToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_column :paintings, :status, :integer, default: 0
  end
end
