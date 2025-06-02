class AddProductIdToRefuelings < ActiveRecord::Migration[7.0]
  def change
    add_reference :refuelings, :product, null: false, foreign_key: true
  end
end
