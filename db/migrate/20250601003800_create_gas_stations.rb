class CreateGasStations < ActiveRecord::Migration[7.0]
  def change
    create_table :gas_stations do |t|
      t.string :name, null: false
      t.references :address, null: false, foreign_key: true, index: false
      t.timestamps
    end

    add_index :gas_stations, :address_id, unique: true
  end
end
