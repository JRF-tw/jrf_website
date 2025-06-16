# Rails 7 升級指南

## 概述
本專案已從 Rails 5.1 升級至 Rails 7.1。以下是生產環境需要注意的變更和遷移步驟。

## 主要變更

### 1. Secret Key Base 遷移
**問題**: Rails 7 棄用了 `Rails.application.secrets`，改用 `Rails.application.credentials`

**解決方案**: 
- 已將secrets遷移到環境變數方式
- 開發和測試環境：在initializer中自動設定
- 生產環境：必須設定環境變數 `SECRET_KEY_BASE`

**生產環境遷移步驟**：

**選項1: 環境變數方式 (推薦)**
```bash
# 1. 備份現有的 secrets.yml
cp config/secrets.yml config/secrets.yml.backup.$(date +%Y%m%d)

# 2. 檢查現有的 secrets.yml 內容
cat config/secrets.yml

# 3. 設定必要的環境變數
export SECRET_KEY_BASE=your_existing_or_new_secret_key_base

# 4. 對於其他secrets，轉換為環境變數
# 例如：secrets.yml 中的 api_key: abc123
# 轉換為：export API_KEY='abc123'

# 5. 更新部署配置 (systemd, Docker, etc.)
# 將環境變數加入到你的部署配置中

# 6. 測試應用啟動
RAILS_ENV=production bundle exec rails runner "puts 'App loads successfully'"

# 7. 確認功能正常後，移除舊檔案
mv config/secrets.yml config/secrets.yml.migrated
```

**選項2: 暫時相容方式**
如果你需要保持現有的secrets.yml暫時不變：
```ruby
# 在 config/application.rb 中添加：
config.secrets = config_for(:secrets)

# 然後將程式碼中的 Rails.application.secrets 
# 替換為 Rails.configuration.secrets
```

**重要提醒**：
- ⚠️ 絕不要將production secrets提交到版本控制
- ⚠️ 先在staging環境測試遷移過程
- ⚠️ 保留secrets備份直到確認遷移成功

**提供的工具**：
- `script/production_secrets_migration.rb` - 生產環境檢查腳本
- `script/migrate_production_secrets.rb` - 遷移輔助腳本

### 2. 設定檔遷移 (Settingslogic → Config gem)
**問題**: Settingslogic gem 在 Rails 7 + Ruby 3.2 中有 YAML aliases 相容性問題

**解決方案**: 
- 已將 `settingslogic` 替換為 `config` gem
- 將 `config.yml` 拆分為：
  - `config/settings.yml` (基本設定)
  - `config/settings/development.yml` (開發環境)
  - `config/settings/test.yml` (測試環境)  
  - `config/settings/production.yml` (生產環境)

**生產環境遷移步驟**：
```bash
# 1. 確保新的設定檔存在
ls -la config/settings/
ls -la config/settings.yml

# 2. 檢查是否有使用到舊的 config.yml
# (如果有自定義設定，請手動遷移到對應的 settings 檔案)

# 3. 重新啟動應用
sudo systemctl restart your-app
# 或
passenger-config restart-app
```

### 3. 前端資源管理
**變更**: 
- 從 Asset Pipeline 遷移到 Importmap + Stimulus + Turbo
- 移除了 `sprockets-rails` 的一些舊設定

**生產環境檢查**：
```bash
# 檢查 assets 是否正常編譯
RAILS_ENV=production bundle exec rails assets:precompile

# 檢查 importmap 設定
RAILS_ENV=production bundle exec rails importmap:install
```

### 4. 資料庫遷移
**狀態**: 無需額外的資料庫遷移，現有 schema 相容

### 5. Gem 更新
主要更新的 gems：
- `rails` 5.1 → 7.1
- `settingslogic` → `config`
- `factory_girl_rails` → `factory_bot_rails`
- 以及其他相依套件的安全性更新

## 生產環境部署檢查清單

### 部署前檢查
- [ ] 確認 `SECRET_KEY_BASE` 環境變數已設定
- [ ] 確認新的設定檔已上傳到伺服器
- [ ] 備份現有的 `config.yml`（如果存在）

### 部署步驟
```bash
# 1. 更新程式碼
git pull origin master

# 2. 安裝新套件
bundle install --deployment --without development test

# 3. 編譯資源
RAILS_ENV=production bundle exec rails assets:precompile

# 4. 重新啟動應用
sudo systemctl restart your-app
```

### 部署後檢查
- [ ] 應用程式正常啟動
- [ ] 前端 CSS/JS 正常載入
- [ ] 使用者認證（OAuth）功能正常
- [ ] 管理後台功能正常
- [ ] 檢查日誌中無 deprecation warnings

## 故障排除

### 常見問題

1. **SECRET_KEY_BASE 錯誤**
   ```
   解決：確保環境變數已正確設定
   export SECRET_KEY_BASE=your_secret_key_here
   ```

2. **設定檔讀取錯誤**
   ```
   錯誤：Setting.url 不存在
   解決：檢查 config/settings.yml 是否存在並格式正確
   ```

3. **Assets 載入問題**
   ```
   解決：重新編譯 assets
   RAILS_ENV=production bundle exec rails assets:clobber assets:precompile
   ```

## 回滾計劃

如果遇到嚴重問題需要回滾：

```bash
# 1. 回滾程式碼
git revert HEAD

# 2. 恢復舊設定檔（如果需要）
mv config.yml.backup config.yml

# 3. 重新安裝舊版 gems
bundle install

# 4. 重新編譯 assets
RAILS_ENV=production bundle exec rails assets:precompile

# 5. 重新啟動
sudo systemctl restart your-app
```

## 聯絡資訊

如果在升級過程中遇到問題，請參考：
- Rails 7.1 升級指南: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html
- Config gem 文件: https://github.com/rubyconfig/config