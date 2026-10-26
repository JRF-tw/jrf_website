# Facebook 已在 2023 年 4 月停止 Instant Articles，這個欄位是存檔時另外轉出來的內容，沒有地方再用到
class RemoveFbIaContentFromArticles < ActiveRecord::Migration[8.1]
  def change
    remove_column :articles, :fb_ia_content, :text
  end
end
