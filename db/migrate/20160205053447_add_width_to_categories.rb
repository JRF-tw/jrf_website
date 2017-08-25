class AddWidthToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :width, :integer, null: false, default: 1
  end
end
