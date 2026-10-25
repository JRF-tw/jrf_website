require "rails_helper"

# code review 找到的邊界情況
describe "異常輸入與舊資料" do
  describe "kind 是空值的已發布文章" do
    let!(:article) { FactoryBot.create(:article, title: "沒有分類的舊文章", kind: nil) }

    it "搜尋得到" do
      get "/search", params: { q: "沒有分類" }
      expect(response.body).to include(article.title)
    end

    it "列在 sitemap" do
      get "/sitemap.xml"
      expect(response.body).to include("/articles/#{article.id}</loc>")
    end
  end

  it "沒有文章時 sitemap 不輸出空的 lastmod" do
    get "/sitemap.xml"
    expect(response.body).not_to include("<lastmod/>")
    expect(response.body).not_to include("<lastmod></lastmod>")
  end

  describe "參數格式不對時不會 500" do
    it "page 是陣列或 hash" do
      get "/", params: { page: ["1"] }
      expect(response.status).to be < 500
      get "/articles", params: { page: { x: "1" } }
      expect(response.status).to be < 500
    end

    it "搜尋關鍵字是 hash" do
      get "/search", params: { q: { foo: "bar" } }
      expect(response.status).to be < 500
    end
  end
end
