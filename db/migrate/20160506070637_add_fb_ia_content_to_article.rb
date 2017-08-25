class AddFbIaContentToArticle < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :fb_ia_content, :text
  end
end