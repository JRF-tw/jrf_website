require "rails_helper"

describe "CKEditor 上傳與瀏覽" do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:image) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.jpg'), 'image/jpeg') }
  let(:pdf) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf') }
  let(:html) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.html'), 'text/html') }

  # 未授權時 ckeditor 的 authorize_with 丟 RoutingError，依 Rails 版本可能是例外或 404
  def expect_not_found
    yield
    expect(response).to have_http_status(:not_found)
  rescue ActionController::RoutingError
  end

  describe "未登入" do
    it "不能瀏覽圖片庫" do
      expect_not_found { get "/ckeditor/pictures" }
    end

    it "不能上傳圖片" do
      expect {
        expect_not_found { post "/ckeditor/pictures", params: { upload: image } }
      }.not_to change { Ckeditor::Picture.count }
    end

    it "不能上傳附件" do
      expect {
        expect_not_found { post "/ckeditor/attachment_files", params: { upload: pdf } }
      }.not_to change { Ckeditor::AttachmentFile.count }
    end
  end

  describe "非管理員" do
    before { sign_in user }

    it "不能瀏覽圖片庫" do
      expect_not_found { get "/ckeditor/pictures" }
    end

    it "不能上傳圖片" do
      expect {
        expect_not_found { post "/ckeditor/pictures", params: { upload: image } }
      }.not_to change { Ckeditor::Picture.count }
    end
  end

  describe "管理員" do
    before { sign_in admin }

    it "從圖片對話框上傳圖片（回傳 JSON）" do
      expect {
        post "/ckeditor/pictures", params: { upload: image, responseType: "json" }
      }.to change { Ckeditor::Picture.count }.by(1)
      body = JSON.parse(response.body)
      expect(body["uploaded"]).to eq(1)
      expect(body["url"]).to match(%r{/uploads/ckeditor/pictures/\d+/test\.jpg})
      picture = Ckeditor::Picture.last
      expect(File.exist?(picture.data.path)).to be true
      expect([picture.width, picture.height]).to eq([1024, 432])
    end

    it "從圖片對話框上傳圖片（舊式 callFunction 回應）" do
      post "/ckeditor/pictures", params: { upload: image, CKEditor: "article_content", CKEditorFuncNum: "1", langCode: "zh" }
      expect(response.body).to include("CKEDITOR.tools.callFunction")
      # 這種回應給的是縮到 800px 以內的 content 版本
      expect(response.body).to match(%r{/uploads/ckeditor/pictures/\d+/content_test\.jpg})
    end

    it "圖片庫拒絕非圖片檔" do
      expect {
        post "/ckeditor/pictures", params: { upload: html, responseType: "json" }
      }.not_to change { Ckeditor::Picture.count }
    end

    it "從連結對話框上傳 PDF 附件" do
      expect {
        post "/ckeditor/attachment_files", params: { upload: pdf, responseType: "json" }
      }.to change { Ckeditor::AttachmentFile.count }.by(1)
      expect(JSON.parse(response.body)["url"]).to match(%r{/uploads/ckeditor/attachments/\d+/test\.pdf})
    end

    it "附件拒絕 HTML 檔，避免放上可執行的網頁" do
      expect {
        post "/ckeditor/attachment_files", params: { upload: html, responseType: "json" }
      }.not_to change { Ckeditor::AttachmentFile.count }
    end

    it "瀏覽圖片庫看得到已上傳的圖片" do
      post "/ckeditor/pictures", params: { upload: image, responseType: "json" }
      get "/ckeditor/pictures", params: { CKEditor: "article_content", CKEditorFuncNum: "1", langCode: "zh" }
      expect(response).to be_successful
      expect(response.body).to include("test.jpg")
    end

    it "瀏覽附件清單看得到已上傳的附件" do
      post "/ckeditor/attachment_files", params: { upload: pdf, responseType: "json" }
      get "/ckeditor/attachment_files", params: { CKEditor: "article_content", CKEditorFuncNum: "1", langCode: "zh" }
      expect(response).to be_successful
      expect(response.body).to include("test.pdf")
    end

    it "刪除已上傳的圖片" do
      post "/ckeditor/pictures", params: { upload: image, responseType: "json" }
      picture = Ckeditor::Picture.last
      expect {
        delete "/ckeditor/pictures/#{picture.id}"
      }.to change { Ckeditor::Picture.count }.by(-1)
    end
  end
end
