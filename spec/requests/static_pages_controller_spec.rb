require "rails_helper"

describe "Static Pages" do

  describe "#home" do
    it "success" do
      2.times { FactoryBot.create :keyword }
      2.times { FactoryBot.create :article }
      get "/"
      expect(response).to be_successful
    end
  end

  describe "#about" do
    it "success" do
      FactoryBot.create :about_article
      get "/about"
      expect(response).to be_successful
    end
  end

  describe "#donate" do
    it "success" do
      FactoryBot.create :donate_article
      get "/donate"
      expect(response).to be_successful
    end
  end

  describe "#sitemap" do
    it "success" do
      2.times { FactoryBot.create :keyword }
      2.times { FactoryBot.create :article }
      get "/sitemap.xml"
      expect(response).to be_successful
    end

    it "lastmod 是實際的修改時間，不列草稿與系統頁" do
      keyword = FactoryBot.create(:keyword)
      article = FactoryBot.create(:press_article, keywords: [keyword])
      article.update_columns(updated_at: Time.zone.parse("2025-05-06 10:00"))
      draft = FactoryBot.create(:press_article, published: false)
      about = FactoryBot.create(:article, kind: "system", system_type: "about", published: true)
      about.update_columns(updated_at: Time.zone.parse("2025-01-02 10:00"))

      get "/sitemap.xml"
      urls = Nokogiri::XML(response.body).remove_namespaces!.xpath("//url").to_h do |u|
        [u.at("loc").text.sub("http://www.example.com", ""), u.at("lastmod")&.text]
      end
      expect(urls).to include("/keywords/#{keyword.id}")
      expect(urls["/keywords/#{keyword.id}"]).to be_nil # 沒有修改時間就不填
      expect(urls["/articles/#{article.id}"]).to eq("2025-05-06")
      expect(urls["/about"]).to eq("2025-01-02")
      expect(urls["/articles"]).to eq("2025-05-06")
      expect(urls).to include("/articles/presses", "/articles/books")
      expect(urls).not_to include("/articles/#{draft.id}", "/articles/#{about.id}")
    end
  end

  describe "#search" do
    let!(:about) { FactoryBot.create :article, kind: "system", system_type: "about", title: "司法改革關於我們" }
    let!(:press) { FactoryBot.create :press_article, title: "司法改革新聞稿" }
    let!(:book) { FactoryBot.create :book_article, title: "司法改革書籍" }

    it "lists matching articles without system pages" do
      get "/search", params: { q: "司法改革" }
      expect(response).to be_successful
      expect(response.body).to include(press.title, book.title, "新聞稿", "搜尋：司法改革")
      expect(response.body).not_to include(about.title)
    end

    it "filters by kind and keeps the query in tab links" do
      get "/search", params: { q: "司法改革", k: "books" }
      expect(response).to be_successful
      expect(response.body).to include(book.title)
      expect(response.body).not_to include(press.title)
      expect(response.body).to include("k=presses&amp;q=")
    end
  end
end