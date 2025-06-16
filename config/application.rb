require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewJrfWebsite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware` subdirectories.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Taipei'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.default_locale = "zh-TW"

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Rails 7.2 compatibility: Use credentials instead of deprecated secrets
    # Production will use RAILS_MASTER_KEY environment variable
    # Development/test will use local key files
    # This approach is fully compatible with Rails 7.2 where secrets are removed
    
    # Configure Rails to use credentials instead of deprecated secrets
    config.credentials.content_path = Rails.root.join("config", "credentials", "#{Rails.env}.yml.enc")
    config.credentials.key_path = Rails.root.join("config", "credentials", "#{Rails.env}.key")

    # Asset paths
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    
    # Custom error pages
    config.exceptions_app = self.routes
  end
end
