class AddThumbnailToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_column :paintings, :thumbnail, :string
  end
end
