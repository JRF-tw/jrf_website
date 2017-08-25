class CreateKeywordsMagazineArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :keywords_magazine_articles do |t|
      t.references :keyword, null: false
      t.references :magazine_article, null: false
    end
    add_index(:keywords_magazine_articles, [:keyword_id, :magazine_article_id], name: "keywords_magazine_articles_index", unique: true)
  end
end
