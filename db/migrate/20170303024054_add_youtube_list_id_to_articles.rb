class AddYoutubeListIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :youtube_list_id, :string
  end
end
