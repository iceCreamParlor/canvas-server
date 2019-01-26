class AddMagazineToMagazineComments < ActiveRecord::Migration[5.2]
  def change
    add_reference :magazine_comments, :magazine, foreign_key: true
  end
end
