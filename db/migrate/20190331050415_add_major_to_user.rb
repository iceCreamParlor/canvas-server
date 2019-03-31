class AddMajorToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :major, :string
  end
end
