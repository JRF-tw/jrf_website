class CreateCatalogs < ActiveRecord::Migration
  def change
    create_table :catalogs do |t|
      t.string :name
      t.string :image
      t.boolean :published, default: true
    end

    add_index :catalogs, :name, unique: true
  end
end
