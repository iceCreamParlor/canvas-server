class CreateConfigSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :config_settings do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
