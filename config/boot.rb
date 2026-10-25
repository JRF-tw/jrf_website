ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
# concurrent-ruby 1.3.5 起不再載入 logger，Rails 7.1 以前的 ActiveSupport 需要它先載入
require 'logger'
