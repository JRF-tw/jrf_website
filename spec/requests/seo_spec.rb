require "rails_helper"

describe "SEO" do
  def head_tag(pattern)
    response.body[pattern, 1]
  end

  def canonical
    head_tag(/<link rel="canonical" href="([^"]*)"/)
  end

  def json_ld
    JSON.parse(head_tag(%r{<script type="application/ld\+json">(.*?)</script>}m))
  end

  describe "canonical" do
    let(:keyword) { FactoryBot.create(:keyword) }

    it "去掉追蹤參數" do
      get "/articles", params: { utm_source: "facebook", fbclid: "abc" }
      expect(canonical).to eq("http://www.example.com/articles")
    end

    it "分頁保留頁碼，第一頁不帶" do
      get "/articles", params: { page: 2 }
      expect(canonical).to eq("http://www.example.com/articles?page=2")
      get "/articles", params: { page: 1 }
      expect(canonical).to eq("http://www.example.com/articles")
    end

    it "專案頁的分類篩選指回專案頁本身" do
      get "/keywords/#{keyword.id}", params: { k: "books" }
      expect(canonical).to eq("http://www.example.com/keywords/#{keyword.id}")
    end
  end

  describe "robots" do
    it "允許搜尋引擎顯示大圖預覽" do
      get "/"
      expect(head_tag(/<meta name="robots" content="([^"]*)"/)).to include("max-image-preview:large")
    end

    it "站內搜尋結果不讓搜尋引擎索引" do
      get "/search", params: { q: "司法" }
      expect(head_tag(/<meta name="robots" content="([^"]*)"/)).to include("noindex")
      get "/articles", params: { q: { title_or_content_or_author_or_keywords_name_cont: "司法" } }
      expect(head_tag(/<meta name="robots" content="([^"]*)"/)).to include("noindex")
    end

    it "一般頁面可以被索引" do
      get "/articles"
      expect(head_tag(/<meta name="robots" content="([^"]*)"/)).not_to include("noindex")
    end
  end

  it "不輸出空白的 author / publisher meta" do
    get "/"
    expect(response.body).not_to match(/<meta name="(author|publisher)" content="">/)
  end

  describe "h1" do
    it "首頁只有一個 h1" do
      2.times { |i| FactoryBot.create(:keyword, showed: true, show_position: i) }
      get "/"
      expect(response.body.scan(/<h1[\s>]/).size).to eq(1)
    end

    it "全部文章頁有 h1" do
      get "/articles"
      expect(response.body.scan(/<h1[\s>]/).size).to eq(1)
    end
  end

  describe "文章頁" do
    let(:article) { FactoryBot.create(:press_article, author: author, description: "<p>摘要\r\n</p>", published_at: Date.new(2026, 1, 2)) }
    let(:author) { "民間司法改革基金會" }

    before { get "/articles/#{article.id}" }

    it "列表圖片都有 alt" do
      expect(response.body).not_to match(/<img(?![^>]*\balt=)[^>]*>/)
    end

    it "發布時間帶台北時區" do
      expect(head_tag(/property="article:published_time" content="([^"]*)"/)).to eq("2026-01-02T00:00:00+08:00")
      expect(json_ld["datePublished"]).to eq("2026-01-02T00:00:00+08:00")
    end

    it "description 沒有多餘的空白與換行" do
      expect(json_ld["description"]).to eq("摘要")
      expect(head_tag(/property="og:description" content="([^"]*)"/)).to eq("摘要")
    end

    it "結構化資料附上 16:9 的大圖" do
      expect(json_ld["image"].first).to match(%r{/uploads/article/image/#{article.id}/banner_test\.jpg\z})
    end

    context "作者是組織" do
      it "標成 Organization" do
        expect(json_ld["author"]).to eq("@type" => "Organization", "name" => "民間司法改革基金會")
      end
    end

    context "作者是個人" do
      let(:author) { "李明洳律師" }

      it "標成 Person" do
        expect(json_ld["author"]).to eq("@type" => "Person", "name" => "李明洳律師")
      end
    end

    context "作者欄位是多人分工或帶職稱" do
      let(:author) { "文字｜Eiley；設計｜Mido；發行｜Jane" }

      it "改用基金會當作者" do
        expect(json_ld["author"]).to include("@type" => "Organization", "name" => "財團法人民間司法改革基金會")
        expect(json_ld["author"]["url"]).to be_present
      end
    end
  end
end
