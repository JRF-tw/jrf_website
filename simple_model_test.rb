#!/usr/bin/env ruby

# Load basic test environment
ENV['RAILS_ENV'] = 'test'

begin
  require_relative 'config/environment'
  
  puts "Rails environment loaded successfully"
  puts "Rails version: #{Rails.version}"
  puts "Database adapter: #{ActiveRecord::Base.connection.adapter_name}"
  
  # Test basic model loading
  puts "\nTesting model loading..."
  
  models = ['Article', 'User', 'Keyword', 'Site', 'Setting']
  
  models.each do |model_name|
    begin
      model_class = model_name.constantize
      puts "✓ #{model_name} - Loaded successfully"
      
      # Test basic methods
      if model_class.respond_to?(:count)
        count = model_class.count
        puts "  - Current #{model_name} count: #{count}"
      end
    rescue => e
      puts "✗ #{model_name} - Error: #{e.message}"
    end
  end
  
rescue => e
  puts "Error loading Rails environment: #{e.message}"
  puts "Backtrace: #{e.backtrace.first(5).join("\n")}"
end