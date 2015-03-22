class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.references :catalog, index: true
      t.boolean :published, default: true
    end

    add_index :categories, :name, unique: true
  end
end
