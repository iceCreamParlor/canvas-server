class CreateWebMagazines < ActiveRecord::Migration[5.2]
  def change
    create_table :web_magazines do |t|
      t.integer :number
      t.string :artist_name
      t.string :image
      t.string :brief
      t.string :content1
      t.string :content2

      t.timestamps
    end
  end
end
