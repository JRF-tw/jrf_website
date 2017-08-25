class CreateEpapers < ActiveRecord::Migration[4.2]
  def change
    create_table :epapers do |t|
      t.string :title
      t.string :filename
      t.text :content
      t.date :published_at
      t.string :image

      t.timestamps null: false
    end
  end
end
