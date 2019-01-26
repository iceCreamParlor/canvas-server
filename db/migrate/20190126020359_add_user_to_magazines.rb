class AddUserToMagazines < ActiveRecord::Migration[5.2]
  def change
    add_reference :magazines, :user, foreign_key: true
  end
end
