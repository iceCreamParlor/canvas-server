class AddThumbnailToMagazines < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :thumbnail, :string
  end
end
