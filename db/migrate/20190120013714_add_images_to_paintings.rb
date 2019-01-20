class AddImagesToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_column :paintings, :images, :json
  end
end
