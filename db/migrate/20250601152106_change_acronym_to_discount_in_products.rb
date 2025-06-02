class ChangeAcronymToDiscountInProducts < ActiveRecord::Migration[7.0]
  def up
    rename_column :products, :acronym, :discount
    change_column :products, :discount, :integer, default: 0, null: false
  end

  def down
    rename_column :products, :discount, :acronym
    change_column :products, :acronym, :string, default: 'gasoline', null: false
  end
end
