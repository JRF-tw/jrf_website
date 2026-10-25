require "rails_helper"

describe "Google / Facebook 登入" do
  before { OmniAuth.config.test_mode = true }
  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.test_mode = false
  end

  def mock(provider, uid:, email:, name: "測試使用者")
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s, uid: uid, info: { email: email, name: name }
    )
  end

  def login_with(provider)
    get "/users/auth/#{provider}/callback"
  end

  %i[google_oauth2 facebook].each do |provider|
    describe provider do
      it "已綁定的管理員登入後進入後台" do
        admin = FactoryBot.create(:admin, provider: provider.to_s, provider_uid: "uid-1")
        mock(provider, uid: "uid-1", email: admin.email)
        login_with(provider)
        expect(response).to redirect_to("/admin/catalogs")
        get "/admin/catalogs"
        expect(response).to be_successful
      end

      it "用 email 找到既有管理員時綁定第三方帳號" do
        admin = FactoryBot.create(:admin)
        mock(provider, uid: "uid-2", email: admin.email)
        login_with(provider)
        expect(response).to redirect_to("/admin/catalogs")
        expect(admin.reload.provider_uid).to eq("uid-2")
        expect(admin.provider).to eq(provider.to_s)
      end

      it "新使用者會建立帳號，但不是管理員所以被登出" do
        mock(provider, uid: "uid-3", email: "new-#{provider}@example.com")
        expect { login_with(provider) }.to change { User.count }.by(1)
        expect(User.last.admin).to be_falsey
        expect(response).to redirect_to("/")
        get "/admin/catalogs"
        expect(response).to redirect_to("/users/sign_in")
      end
    end
  end

  describe "從登入頁開始登入" do
    let(:admin) { FactoryBot.create(:admin, provider: "google_oauth2", provider_uid: "uid-9") }
    before { mock(:google_oauth2, uid: "uid-9", email: admin.email) }

    # 測試環境預設關閉 CSRF 保護，這裡打開才會跟正式站一樣產生並檢查 token
    around do |example|
      ActionController::Base.allow_forgery_protection = true
      example.run
    ensure
      ActionController::Base.allow_forgery_protection = false
    end

    # 跟瀏覽器一樣，從登入頁的 button_to 表單拿 CSRF token 再送出
    def start_login(origin: nil)
      get "/users/sign_in"
      form = Nokogiri::HTML(response.body).at_css("form[action='/users/auth/google_oauth2']")
      token = form.at_css("input[name=authenticity_token]")["value"]
      post "/users/auth/google_oauth2", params: { authenticity_token: token, origin: origin }.compact
    end

    it "登入頁的按鈕可以登入" do
      start_login
      expect(response).to redirect_to("/users/auth/google_oauth2/callback")
      follow_redirect!
      expect(response).to redirect_to("/admin/catalogs")
    end

    it "站內路徑會導回去" do
      start_login(origin: "/admin/articles")
      follow_redirect!
      expect(response).to redirect_to("/admin/articles")
    end

    it "站外網址不會導過去" do
      start_login(origin: "//evil.example.com/")
      follow_redirect!
      expect(response).to redirect_to("/admin/catalogs")
    end

    it "沒有 CSRF token 的 POST 不會開始登入" do
      begin
        post "/users/auth/google_oauth2"
      rescue ActionController::InvalidAuthenticityToken
        next
      end
      expect(response.location.to_s).not_to include("/callback")
    end

    it "不能用 GET 開始登入（CVE-2015-9284）" do
      get "/users/auth/google_oauth2"
      expect(response.location.to_s).not_to include("/callback")
    end
  end

  describe "登入失敗" do
    it "導回登入頁並顯示原因" do
      OmniAuth.config.mock_auth[:google_oauth2] = :access_denied
      login_with(:google_oauth2)
      expect(response).to redirect_to("/users/sign_in")
      follow_redirect!
      expect(response).to be_successful
      expect(flash[:alert]).to be_present
    end
  end
end
