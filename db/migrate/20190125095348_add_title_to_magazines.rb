class AddTitleToMagazines < ActiveRecord::Migration[5.2]
  def change
    add_column :magazines, :title, :string
    add_column :magazines, :content, :string
  end
end
