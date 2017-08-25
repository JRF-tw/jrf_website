class CreateCatalogs < ActiveRecord::Migration[4.2]
  def change
    create_table :catalogs do |t|
      t.string :name
      t.string :image
      t.boolean :published, default: true
      t.integer :position
    end

    add_index :catalogs, :name, unique: true
  end
end
