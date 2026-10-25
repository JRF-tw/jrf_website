require "rails_helper"

describe "圖片上傳" do
  def upload(name, type = "image/jpeg")
    Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", name), type)
  end

  def dimensions(path)
    MiniMagick::Image.open(path).dimensions
  end

  describe ImageUploader do
    let(:article) { FactoryBot.create(:press_article, image: upload("test.jpg")) }

    it "產生 480x270 縮圖與 1600x900 banner" do
      expect(dimensions(article.image.thumb.path)).to eq([480, 270])
      expect(dimensions(article.image.banner.path)).to eq([1600, 900])
    end

    it "縮圖會壓縮" do
      expect(ImageOptimizer).to receive(:new).with(kind_of(String), { quiet: true, quality: 50 }).at_least(:once).and_call_original
      article
    end

    it "拒絕非圖片的副檔名" do
      article = FactoryBot.build(:press_article, image: upload("test.html", "text/html"))
      expect(article).not_to be_valid
    end

    it "拒絕偽裝成圖片的 HTML（依檔案內容判斷，不信任瀏覽器宣告的類型）" do
      Dir.mktmpdir do |dir|
        fake = File.join(dir, "fake.jpg")
        FileUtils.cp(Rails.root.join("spec", "fixtures", "test.html"), fake)
        article = FactoryBot.build(:press_article, image: Rack::Test::UploadedFile.new(fake, "image/jpeg"))
        expect(article).not_to be_valid
      end
    end
  end

  describe CkeditorPictureUploader do
    it "記錄圖片尺寸並產生縮圖與內文版本" do
      picture = Ckeditor::Picture.create!(data: upload("test.jpg"))
      expect([picture.width, picture.height]).to eq([1024, 432])
      expect(dimensions(picture.data.thumb.path)).to eq([118, 100])
      expect(dimensions(picture.data.content.path)).to eq([800, 338])
    end
  end
end
