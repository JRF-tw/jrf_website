# Setting 在其他 initializer（例如 devise.rb 的 OAuth 設定）就要用到，
# Rails 7 不允許初始化階段自動載入 app/ 底下的類別，所以放在 lib/ 直接載入
require Rails.root.join('lib', 'setting')
