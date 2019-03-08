class CreateRegisterSellers < ActiveRecord::Migration[5.2]
  def change
    create_table :register_sellers do |t|
      t.references :user, foreign_key: true
      t.json :images
      t.boolean :is_confirmed, default: false

      t.timestamps
    end
  end
end
