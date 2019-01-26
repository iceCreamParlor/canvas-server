class CreateMagazineComments < ActiveRecord::Migration[5.2]
  def change
    create_table :magazine_comments do |t|
      t.references :user, foreign_key: true
      t.string :content

      t.timestamps
    end
  end
end
