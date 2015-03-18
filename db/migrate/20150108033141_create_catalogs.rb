class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :name
      t.string :image
    end

    add_index :catalogs, :name, unique: true
  end
end
