require "rails_helper"

describe "Article" do

  let(:press_article) { FactoryBot.create(:press_article) }
  let(:activity_article) { FactoryBot.create(:activity_article) }
  let(:comment_article) { FactoryBot.create(:comment_article) }

  describe "#presses" do
    it "success" do
      2.times { FactoryBot.create(:press_article) }
      get "/articles/presses"
      expect(response).to be_successful
    end
  end

  describe "#press_show" do
    it "success" do
      get "/articles/#{press_article.id}"
      expect(response).to be_successful
    end
  end

  describe "#activities" do
    it "success" do
      2.times { FactoryBot.create(:activity_article) }
      get "/articles/activities"
      expect(response).to be_successful
    end
  end

  describe "#activity_show" do
    it "success" do
      get "/articles/#{activity_article.id}"
      expect(response).to be_successful
    end
  end

  describe "#comments" do
    it "success" do
      2.times { FactoryBot.create(:comment_article) }
      get "/articles/comments"
      expect(response).to be_successful
    end
  end

  describe "#comment_show" do
    it "success" do
      get "/articles/#{comment_article.id}"
      expect(response).to be_successful
    end
  end

  describe "#epapers" do
    it "success" do
      epaper = FactoryBot.create(:epaper_article)
      get "/articles/epapers"
      expect(response).to be_successful
      expect(response.body).to include(epaper.title)
    end
  end

  describe "#books" do
    it "success" do
      book = FactoryBot.create(:book_article)
      get "/articles/books"
      expect(response).to be_successful
      expect(response.body).to include(book.title)
    end
  end

  describe "#index" do
    let!(:published) { FactoryBot.create(:press_article, title: "已發布的文章") }
    let!(:draft) { FactoryBot.create(:press_article, title: "草稿文章", published: false) }

    it "只列出已發布的文章" do
      get "/articles"
      expect(response).to be_successful
      expect(response.body).to include(published.title)
      expect(response.body).not_to include(draft.title)
    end

    it "管理員看得到草稿" do
      sign_in FactoryBot.create(:admin)
      get "/articles"
      expect(response.body).to include(draft.title)
    end
  end

  describe "JSON" do
    let!(:press) { FactoryBot.create(:press_article, title: "司法改革新聞稿") }
    let!(:book) { FactoryBot.create(:book_article, title: "其他書籍") }
    let!(:draft) { FactoryBot.create(:press_article, title: "司法改革草稿", published: false) }

    it "所有文章" do
      get "/articles.json"
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      expect(body["count"]).to eq(2)
      expect(body["articles"].map { |a| a["title"] }).to contain_exactly(press.title, book.title)
      expect(body["articles"].first).not_to have_key("published")
      expect(body["articles"].first["keywords"]).to be_an(Array)
    end

    it "用關鍵字搜尋並分頁" do
      get "/articles.json", params: { query: "司法改革", limit: 1, offset: 0 }
      body = JSON.parse(response.body)
      expect(body["count"]).to eq(1)
      expect(body["articles"].map { |a| a["title"] }).to eq([press.title])
    end

    it "分類頁" do
      get "/articles/presses.json"
      expect(JSON.parse(response.body)["articles"].map { |a| a["title"] }).to eq([press.title])
      get "/articles/books.json", params: { query: "書籍" }
      expect(JSON.parse(response.body)["articles"].map { |a| a["title"] }).to eq([book.title])
    end

    it "單篇文章" do
      get "/articles/#{press.id}.json"
      expect(JSON.parse(response.body)["article"]["title"]).to eq(press.title)
    end
  end

  describe "草稿文章" do
    let(:draft) { FactoryBot.create(:press_article, published: false) }

    it "一般訪客看不到" do
      begin
        get "/articles/#{draft.id}"
      rescue ActionController::RoutingError
        next
      end
      expect(response).to have_http_status(:not_found)
    end

    it "管理員可以預覽" do
      sign_in FactoryBot.create(:admin)
      get "/articles/#{draft.id}"
      expect(response).to be_successful
    end
  end
end