require "spec_helper"

describe "Keyword" do


  let(:keyword) { FactoryBot.create(:keyword) }
  let(:new_keyword) do
    {
      name: "new_keyword_name",
    }
  end

  describe "#show" do
    it "success" do
      get "/keywords/#{keyword.id}"
      expect(response).to be_successful
    end
  end

  describe "#show_with_faq" do
    it "success" do
      2.times { FactoryBot.create(:faq, keyword: keyword) }
      get "/keywords/#{keyword.id}"
      expect(response).to be_successful
    end
  end

  describe "分類篩選" do
    let!(:press) { FactoryBot.create(:press_article, title: "專案的新聞稿", keywords: [keyword]) }
    let!(:book) { FactoryBot.create(:book_article, title: "專案的書籍", keywords: [keyword]) }

    it "沒有指定分類時列出全部" do
      get "/keywords/#{keyword.id}"
      expect(response.body).to include(press.title, book.title)
    end

    it "指定分類時只列出該分類" do
      get "/keywords/#{keyword.id}", params: { k: "books" }
      expect(response.body).to include(book.title)
      expect(response.body).not_to include(press.title)
    end

    it "不認得的分類當作全部" do
      get "/keywords/#{keyword.id}", params: { k: "evil" }
      expect(response).to be_successful
      expect(response.body).to include(press.title, book.title)
    end
  end

  describe "未發布的專案" do
    let(:draft) { FactoryBot.create(:keyword, published: false) }

    it "一般訪客看不到" do
      begin
        get "/keywords/#{draft.id}"
      rescue ActionController::RoutingError
        next
      end
      expect(response).to have_http_status(:not_found)
    end

    it "管理員可以預覽" do
      sign_in FactoryBot.create(:admin)
      get "/keywords/#{draft.id}"
      expect(response).to be_successful
    end
  end

  describe "JSON" do
    it "包含 FAQ 與文章" do
      FactoryBot.create(:faq, keyword: keyword, question: "常見問題一")
      FactoryBot.create(:press_article, title: "專案文章", keywords: [keyword])
      get "/keywords/#{keyword.id}.json"
      body = JSON.parse(response.body)
      expect(body["status"]).to eq("success")
      expect(body["keyword"]["faqs"].map { |f| f["question"] }).to eq(["常見問題一"])
      expect(body["keyword"]["articles"].map { |a| a["title"] }).to eq(["專案文章"])
      expect(body["keyword"]).not_to have_key("published")
    end
  end
end