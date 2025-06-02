class AddAcronymToProducts < ActiveRecord::Migration[7.0]
  def up
    add_column :products, :acronym, :string, null: false, default: 'gasoline'
  end

  def down
    remove_column :products, :acronym
  end
end
