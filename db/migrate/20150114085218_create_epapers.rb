class CreateEpapers < ActiveRecord::Migration
  def change
    create_table :epapers do |t|
      t.string :title
      t.string :filename
      t.text :content
      t.date :published_at

      t.timestamps null: false
    end
  end
end
