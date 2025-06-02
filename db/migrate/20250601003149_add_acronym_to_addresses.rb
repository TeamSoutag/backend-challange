class AddAcronymToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :acronym, :string
  end
end
