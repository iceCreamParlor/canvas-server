class AddCompletedDateToPaintings < ActiveRecord::Migration[5.2]
  def change
    add_column :paintings, :completed_date, :datetime, default: Time.now
  end
end
