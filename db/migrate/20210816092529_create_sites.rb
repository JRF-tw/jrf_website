class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites, id: :serial do |t|
      t.string :title
      t.string :link
      t.integer :position
      t.boolean :published
    end
  end
end
