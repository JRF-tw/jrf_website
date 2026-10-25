# OmniAuth 2 預設只允許用 POST（帶 CSRF token）開始 OAuth 登入，避免 CVE-2015-9284，
# 登入頁的按鈕用 button_to 送出 POST；登入失敗交給 Devise 導回登入頁並顯示原因

# Add logger for debugging OAuth issues
if Rails.env.development?
  OmniAuth.config.logger = Rails.logger
end
