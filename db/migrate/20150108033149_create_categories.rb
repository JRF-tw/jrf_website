class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.references :catalog, index: true
      t.boolean :published, default: true
      t.integer :position
    end

    add_index :categories, :name, unique: true
  end
end
