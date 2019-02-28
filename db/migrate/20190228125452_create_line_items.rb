class CreateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :line_items do |t|
      t.integer :state
      t.references :order, foreign_key: true
      t.references :option, foreign_key: true
      t.references :painting, foreign_key: true
      t.integer :quantity
      t.integer :amount
      t.integer :shipment_cost

      t.timestamps
    end
  end
end
