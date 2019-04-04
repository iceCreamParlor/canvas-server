class AddWebMagazineGroupIdToWebMagazines < ActiveRecord::Migration[5.2]
  def change
    add_reference :web_magazines, :web_magazine_group, foreign_key: true
  end
end
