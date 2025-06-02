class ChangeAcronymTypeToIntegerInAddresses < ActiveRecord::Migration[6.0]
  def up
    change_column :addresses, :acronym, :integer, using: 'acronym::integer'
  end

  def down
    change_column :addresses, :acronym, :string
  end
end
