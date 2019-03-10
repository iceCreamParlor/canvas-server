class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :state
      t.integer :shipment_state
      t.string :uid
      t.string :order_number
      t.string :shipment_number
      t.integer :item_total
      t.integer :shipment_total
      t.references :user, foreign_key: true
      t.string :name
      t.string :phone
      t.string :zipcode
      t.string :address1
      t.string :address2
      t.decimal :payment_amount
      t.string :payment_info
      t.string :note
      t.datetime :completed_at
      t.integer :payment_method
      t.datetime :shipped_at

      t.timestamps
    end
  end
end
