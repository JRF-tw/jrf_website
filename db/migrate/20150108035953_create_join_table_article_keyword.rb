class CreateJoinTableArticleKeyword < ActiveRecord::Migration[4.2]
  def change
    create_table :articles_keywords, id: false do |t|
      t.references :article, null: false
      t.references :keyword, null: false
    end
    add_index(:articles_keywords, [:article_id, :keyword_id], unique: true)
  end
end
