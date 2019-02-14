class ChangeSellerIdToSenderId < ActiveRecord::Migration[5.2]
  def change
    rename_column :messages, :seller_id, :receiver_id
    rename_column :messages, :buyer_id, :sender_id
  end
end
