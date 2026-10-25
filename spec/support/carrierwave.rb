# 測試上傳的檔案存到 tmp/，避免蓋掉開發環境 public/uploads 底下同 id 的檔案
CarrierWave.configure do |config|
  config.root = Rails.root.join('tmp', 'test_uploads')
end

RSpec.configure do |config|
  config.after(:suite) { FileUtils.rm_rf(Rails.root.join('tmp', 'test_uploads')) }
end
