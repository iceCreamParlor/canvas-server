class AddMagazineTypeToMagazines < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :magazine_type, :integer, default: 0
    add_column :magazines, :priority, :integer, default: 0
  end
end
