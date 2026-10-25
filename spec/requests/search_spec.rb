require "rails_helper"

# 網站各處用 Ransack 搜尋的欄位；Ransack 4 起每個 model 都要明確允許可搜尋的欄位
describe "搜尋" do
  let(:keyword) { FactoryBot.create(:keyword, name: "冤案平反") }
  let!(:matched) { FactoryBot.create(:press_article, title: "第一篇", keywords: [keyword]) }
  let!(:other) { FactoryBot.create(:book_article, title: "第二篇", published_at: 1.year.ago) }

  it "前台搜尋框可以搜文章的關鍵字名稱" do
    get "/articles", params: { q: { title_or_content_or_author_or_keywords_name_cont: "冤案" } }
    expect(response.body).to include(matched.title)
    expect(response.body).not_to include(other.title)
  end

  it "不能透過關聯搜尋使用者資料" do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:press_article, title: "管理員寫的", user: admin)
    get "/articles", params: { q: { user_email_cont: admin.email } }
    # 不允許的條件會被忽略，所以不會只剩下管理員寫的那篇
    expect(response.body).to include(matched.title)
  end

  describe "API" do
    it "文章依分類、關鍵字與日期搜尋" do
      get "/api/articles", params: { kind: "press" }, headers: { "Accept" => "application/json" }
      expect(response.body).to include(matched.title)
      expect(response.body).not_to include(other.title)
      get "/api/articles", params: { query: "第二", date_start: 2.years.ago.to_date.to_s, date_end: Date.today.to_s },
                           headers: { "Accept" => "application/json" }
      expect(response.body).to include(other.title)
      expect(response.body).not_to include(matched.title)
    end

    it "專案依名稱搜尋" do
      get "/api/keywords", params: { query: "冤案" }, headers: { "Accept" => "application/json" }
      expect(response.body).to include("冤案平反")
    end

    it "主目錄依名稱搜尋" do
      catalog = keyword.category.catalog
      get "/api/catalogs", params: { query: catalog.name }, headers: { "Accept" => "application/json" }
      expect(response.body).to include(catalog.name)
    end
  end

  describe "後台" do
    before { sign_in FactoryBot.create(:admin) }

    it "文章依標題內文搜尋" do
      get "/admin/articles", params: { q: { title_or_content_cont: "第二" } }
      expect(response.body).to include(other.title)
      expect(response.body).not_to include(matched.title)
    end

    it "專案依目錄篩選並搜尋名稱" do
      another = FactoryBot.create(:keyword, name: "另一個專案")
      get "/admin/keywords", params: { q: { category_id_eq: keyword.category_id, name_or_title_or_content_cont: "冤案" } }
      expect(response.body).to include("冤案平反")
      expect(response.body).not_to include(another.name)
    end

    it "使用者依姓名或 email 搜尋" do
      target = FactoryBot.create(:user, name: "要找的人")
      get "/admin/users", params: { q: { name_or_email_cont: target.email } }
      expect(response.body).to include("要找的人")
    end

    it "主目錄、次目錄、相關網站列表" do
      get "/admin/catalogs"
      expect(response).to be_successful
      get "/admin/categories"
      expect(response).to be_successful
      get "/admin/sites"
      expect(response).to be_successful
    end
  end
end
