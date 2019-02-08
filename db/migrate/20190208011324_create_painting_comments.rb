class CreatePaintingComments < ActiveRecord::Migration[5.2]
  def change
    create_table :painting_comments do |t|
      t.references :user, foreign_key: true
      t.string :content
      t.references :painting, foreign_key: true

      t.timestamps
    end
  end
end
