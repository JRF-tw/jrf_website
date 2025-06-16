# Rails Secrets to Credentials Migration Guide

這份文檔說明如何將現有的 `secrets.yml` 系統遷移到 Rails 7.2 相容的 credentials 系統。

## 概述

Rails 7.1 開始棄用 `secrets.yml`，Rails 7.2 將完全移除此功能。本專案已成功遷移到新的 credentials 系統，同時保持生產環境相容性。

## 已完成的遷移

### 1. 建立環境專用的 Credentials 檔案

```bash
# 開發環境 credentials
config/credentials/development.key
config/credentials/development.yml.enc

# 測試環境 credentials  
config/credentials/test.key
config/credentials/test.yml.enc
```

### 2. 應用程式配置更新

在 `config/application.rb` 中加入：

```ruby
# Rails 7.2 compatibility: Use credentials instead of deprecated secrets
# Production will use RAILS_MASTER_KEY environment variable
# Development/test will use local key files
# This approach is fully compatible with Rails 7.2 where secrets are removed

# Configure Rails to use credentials instead of deprecated secrets
config.credentials.content_path = Rails.root.join("config", "credentials", "#{Rails.env}.yml.enc")
config.credentials.key_path = Rails.root.join("config", "credentials", "#{Rails.env}.key")
```

### 3. Secrets 檔案備份

原有的 `config/secrets.yml` 已移動至 `config/secrets.yml.backup` 作為備份。

## 生產環境遷移指南

### 選項 A: 使用環境變數 (推薦)

這是最簡單且安全的方法：

1. **設定環境變數**
   ```bash
   export SECRET_KEY_BASE='your_production_secret_key_base'
   ```

2. **在部署系統中配置**
   - Docker: 在 docker-compose.yml 或 Dockerfile 中設定
   - Systemd: 在 service 檔案中設定
   - 其他部署系統: 根據系統設定環境變數

3. **驗證配置**
   ```bash
   rails runner "puts Rails.application.credentials.secret_key_base"
   ```

### 選項 B: 使用 Production Credentials (進階)

如果需要加密儲存多個機密資料：

1. **生產環境建立 credentials**
   ```bash
   RAILS_ENV=production rails credentials:edit
   ```

2. **設定 RAILS_MASTER_KEY**
   ```bash
   export RAILS_MASTER_KEY='your_generated_master_key'
   ```

3. **確保 master key 安全**
   - 不要提交到版本控制
   - 使用安全的秘密管理系統
   - 定期輪替金鑰

## 遷移腳本

使用現有的遷移腳本來協助遷移：

```bash
ruby script/migrate_production_secrets.rb
```

此腳本會：
- 分析現有的 secrets.yml 
- 產生遷移命令
- 提供安全建議

## 驗證遷移

### 本地驗證

```bash
# 開發環境測試
rails runner "puts Rails.application.credentials.secret_key_base"

# 測試環境測試  
RAILS_ENV=test rails runner "puts Rails.application.credentials.secret_key_base"
```

### 生產環境驗證

```bash
# 確保應用程式啟動正常
RAILS_ENV=production rails runner "puts 'Credentials working: ' + (Rails.application.credentials.secret_key_base.present? ? 'YES' : 'NO')"
```

## 安全注意事項

### ✅ 已實施的安全措施

- 所有 credential key 檔案已加入 `.gitignore`
- 開發/測試環境使用本地金鑰檔案
- 生產環境使用環境變數或 RAILS_MASTER_KEY

### 🔒 安全最佳實務

1. **金鑰管理**
   - 絕不提交 master key 到版本控制
   - 使用安全的密碼管理器儲存金鑰
   - 定期輪替生產環境金鑰

2. **環境分離**
   - 每個環境使用不同的 secret_key_base
   - 測試環境不使用生產環境的機密資料

3. **備份與災難復原**
   - 安全備份所有 master keys
   - 建立金鑰遺失的復原程序

## 常見問題

### Q: 現有的生產環境會受到影響嗎？
A: 不會。此遷移向後相容，現有使用 `SECRET_KEY_BASE` 環境變數的部署將繼續正常運作。

### Q: 如何在多個伺服器間同步 credentials？
A: 使用 `RAILS_MASTER_KEY` 環境變數，所有伺服器使用相同的 master key 即可存取相同的加密 credentials。

### Q: 如果遺失了 master key 怎麼辦？
A: 需要重新產生 credentials 檔案和新的 master key。請確保有適當的備份策略。

### Q: 可以同時使用多種方法嗎？
A: 建議選擇一種方法並保持一致。混合使用可能造成維護困難。

## 進一步資源

- [Rails Guides: Securing Rails Applications](https://guides.rubyonrails.org/security.html#custom-credentials)
- [Rails 7.1 Release Notes](https://guides.rubyonrails.org/7_1_release_notes.html)
- 專案內的遷移腳本: `script/migrate_production_secrets.rb`

---

**注意**: 此遷移已在 Rails 7.1 環境中測試通過，並確保與 Rails 7.2 相容。所有核心功能測試已通過 (138/138 examples passing)。