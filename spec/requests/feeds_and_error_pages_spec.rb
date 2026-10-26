require "rails_helper"

describe "RSS／Atom 與錯誤頁" do
  let!(:article) { FactoryBot.create(:article) }

  it "Atom feed" do
    get "/feed.atom"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include(article.title)
  end

  it "Atom feed 只放最新的文章，不放系統頁" do
    about = FactoryBot.create(:article, kind: 'system', system_type: 'about', published_at: 1.hour.from_now)
    article.update_column(:published_at, 1.year.ago)
    FactoryBot.create_list(:article, StaticPagesController::FEED_SIZE, published_at: 1.day.ago)
    get "/feed.atom"
    expect(response.body.scan("<entry>").size).to eq(StaticPagesController::FEED_SIZE)
    expect(response.body).not_to include("<title>#{about.title}</title>")
    # 最舊的那篇被擠出去
    expect(response.body).not_to include("<title>#{article.title}</title>")
  end

  it "Atom feed 沒有變動時回 304" do
    get "/feed.atom"
    get "/feed.atom", headers: { "If-None-Match" => response.headers["ETag"] }
    expect(response).to have_http_status(:not_modified)
  end

  describe "錯誤頁" do
    around do |example|
      env = Rails.application.env_config
      original = env.slice("action_dispatch.show_exceptions", "action_dispatch.show_detailed_exceptions")
      # 跟正式站一樣交給 ErrorsController 畫錯誤頁，不顯示 Rails 的除錯頁
      env["action_dispatch.show_exceptions"] = :all
      env["action_dispatch.show_detailed_exceptions"] = false
      example.run
    ensure
      env.merge!(original)
    end

    # 未登入連 /ckeditor/pictures 會 404；ApplicationController 對 /ckeditor/ 不準備頁首資料，
    # Accept 是 */* 時錯誤頁的頁首會因為沒有 @article_q 而變成 500
    it "略過頁首資料的請求、Accept 是 */* 時仍顯示 404 頁" do
      allow_any_instance_of(ErrorsController).to receive(:ckeditor_request?).and_return(true)
      get "/no-such-page", headers: { "Accept" => "*/*" }
      expect(response).to have_http_status(:not_found)
      expect(response.media_type).to eq("text/html")
      expect(response.body).to include('lang="zh-Hant-TW"')
    end
  end
end
