class CreateRefuelings < ActiveRecord::Migration[7.0]
  def change
    create_table :refuelings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gas_station, null: false, foreign_key: true
      t.decimal :liters, null: false, precision: 10, scale: 2
      t.decimal :total_price, null: false, precision: 10, scale: 2
      t.decimal :discount_applied, null: false, precision: 5, scale: 2

      t.timestamps
    end
  end
end
