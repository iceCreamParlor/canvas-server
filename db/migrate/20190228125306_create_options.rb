class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.references :painting, foreign_key: true
      t.string :title
      t.string :price
      t.string :integer
      t.integer :position

      t.timestamps
    end
  end
end
