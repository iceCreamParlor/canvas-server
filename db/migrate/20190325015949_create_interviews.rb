class CreateInterviews < ActiveRecord::Migration[5.2]
  def change
    create_table :interviews do |t|
      t.references :web_magazine, foreign_key: true
      t.integer :position
      t.integer :order
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
