class RemoveColumnsAndMagazines < ActiveRecord::Migration[4.2]
  def change
    drop_table :columns
    drop_table :magazines
    drop_table :magazine_articles
    drop_table :keywords_magazine_articles
    drop_table :epapers
  end
end
