source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.8'

# Rails and core gems
gem 'rails', '~> 7.1.0'
gem 'sprockets-rails'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'redis', '~> 5.0'
gem 'bootsnap', require: false

# Asset pipeline
gem 'sassc-rails'

# JavaScript and UI
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'chosen-rails'

# Authentication and authorization
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Content management
gem 'ckeditor'
gem 'carrierwave'
gem 'mini_magick'
gem 'image_processing', '~> 1.2'

# Pagination and search
gem 'kaminari'
gem 'ransack'

# UI and styling
gem 'simple_form'
gem 'slim-rails'
gem 'bootstrap', '~> 5.3'
gem "font-awesome-sass", "~> 6.5.0"
gem 'meta-tags'
gem 'social-share-button'

# File uploads and processing
gem 'carrierwave-imageoptimizer'

# API
gem 'rabl-rails'

# Configuration and utilities
gem 'config'
gem "cocoon"
gem 'unicode-display_width'

# Monitoring and logging
gem 'lograge'

# Internationalization
gem "rails-i18n", '~> 7.0'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner-active_record'
  gem 'bullet'
  gem 'simplecov', require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end