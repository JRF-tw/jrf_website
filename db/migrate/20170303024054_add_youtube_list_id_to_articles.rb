class AddYoutubeListIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :youtube_list_id, :string
  end
end
