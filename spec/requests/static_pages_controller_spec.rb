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