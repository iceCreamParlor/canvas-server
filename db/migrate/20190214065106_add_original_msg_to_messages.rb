class AddOriginalMsgToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :original_msg_id, :integer
  end
  
end
