require File.expand_path('../boot', __FILE__)

# 只載入有用到的元件；Active Storage、Action Cable、Action Mailbox、Action Text 沒有使用
require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewJrfWebsite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # 5.2 預設的 6.1 快取格式在 Rails 7.2 移除；7.1 格式讀得懂舊格式的快取
    config.active_support.cache_format_version = 7.1
    # Rails 8.1 起 to_time 保留完整時區（Asia/Taipei 而不只是 +08:00 偏移），先改用新行為
    config.active_support.to_time_preserves_timezone = :zone

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Taipei'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = "zh-TW"

    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.exceptions_app = self.routes
  end
end
