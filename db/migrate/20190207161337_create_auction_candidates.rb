class CreateAuctionCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :auction_candidates do |t|
      t.references :user, foreign_key: true
      t.references :auction, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
