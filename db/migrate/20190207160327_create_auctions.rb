class CreateAuctions < ActiveRecord::Migration[5.2]
  def change
    create_table :auctions do |t|
      t.references :user, foreign_key: true
      t.references :painting, foreign_key: true
      t.datetime :expire_date, default: Time.zone.now + 2.week
      t.timestamps
    end
  end
end
