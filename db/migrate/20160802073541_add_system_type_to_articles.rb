class AddSystemTypeToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :system_type, :string
  end
end
