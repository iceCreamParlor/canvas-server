class AddDescToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :desc, :string
    add_column :users, :instagram, :string
  end
end
