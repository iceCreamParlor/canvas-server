class AddDescToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_column :paintings, :desc, :string
  end
end
