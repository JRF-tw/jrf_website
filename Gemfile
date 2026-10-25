source 'https://rubygems.org'

gem "bundler", ">= 1.8.4"
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.4'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

gem 'jquery-turbolinks'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# 讓 OmniAuth 用 Rails 的 CSRF token 驗證 POST 登入請求
gem 'omniauth-rails_csrf_protection'
gem 'meta-tags'
gem 'devise'
gem 'simple_form'
gem 'slim-rails', '~> 3.2'
gem 'slim', '~> 4.1'
gem 'factory_bot_rails', group: :test
gem 'kaminari'
gem 'jquery-ui-rails'
# chosen-rails 1.10（最後一版）只在 Rails 4～7 自動載入 engine，Rails 8 要明確載入才找得到 asset
gem 'chosen-rails', require: ['chosen-rails', 'chosen-rails/engine']
gem 'carrierwave', '~> 3.1'
gem 'mini_magick'
gem 'settingslogic'
gem 'ckeditor', '5.1.2'
gem 'pg'
gem 'ransack'
gem "twitter-bootstrap-rails"
# gem "font-awesome-rails"  # Replaced with Font Awesome 5 CDN
# gem 'magnific-popup-rails'
# gem 'owlcarousel-rails'
# gem "animate-rails"
# gem 'google-webfonts'
# gem 'modernizr-rails'
gem 'social-share-button'
gem 'unicode-display_width', '~> 3.1'
gem 'jquery-datetimepicker-rails'
gem "cocoon"
# 縮圖壓縮；原本的 carrierwave-imageoptimizer 只是包一層呼叫，且不支援 CarrierWave 3
gem 'image_optimizer'
gem 'rabl-rails'
gem 'responders', '~> 3.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'sprockets', '~> 3.7.0'
# json 3.1 拿掉了 create_additions 參數，sprockets 3.7 與 execjs 還在用；維持 Ruby 內建的 json 2.x
gem 'json', '< 3'
gem 'lograge'
gem "rails-i18n", '~> 8.0'
gem 'nokogiri'
source 'https://rails-assets.org' do
  gem 'rails-assets-magnific-popup'
  gem 'rails-assets-animate.css'
  # gem 'rails-assets-owl-carousel'
  gem 'rails-assets-modernizr', '~> 2.8.3'
  gem 'rails-assets-isotope'
  gem 'rails-assets-jquery'
  gem 'rails-assets-jquery-appear'
  gem 'rails-assets-mhuggins--jquery-countTo'
  gem 'rails-assets-jquery.parallax'
  gem 'rails-assets-jquery.validate'
  # isotope 的間接依賴；新版 bundler 要求在同一個 source 區塊列出才會從 rails-assets.org 找
  gem 'rails-assets-desandro-matches-selector'
  gem 'rails-assets-ev-emitter'
  gem 'rails-assets-fizzy-ui-utils'
  gem 'rails-assets-get-size'
  gem 'rails-assets-masonry-layout'
  gem 'rails-assets-outlayer'
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'web-console', '>= 4.0', group: :development
# Ruby 3 起不再內建 WEBrick，開發用的 rails server 需要它（正式站用 unicorn）
gem 'webrick', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'minitest'
  gem "capybara"
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem "bullet"
  gem 'simplecov'
end

