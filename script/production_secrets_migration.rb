#!/usr/bin/env ruby
# Production Secrets Migration Check Script for Rails 7 Upgrade

puts "=== Rails 7 Production Secrets Migration Check ==="
puts

# Check if we're in production environment
if ENV['RAILS_ENV'] != 'production'
  puts "⚠️  This script should be run in production environment"
  puts "   Set RAILS_ENV=production to run this check"
  puts
end

# Check 1: SECRET_KEY_BASE environment variable
puts "1. Checking SECRET_KEY_BASE environment variable..."
if ENV['SECRET_KEY_BASE']
  if ENV['SECRET_KEY_BASE'].length >= 30
    puts "✅ SECRET_KEY_BASE is set and appears to be a valid length (#{ENV['SECRET_KEY_BASE'].length} characters)"
  else
    puts "❌ SECRET_KEY_BASE is set but too short (#{ENV['SECRET_KEY_BASE'].length} characters)"
    puts "   It should be at least 30 characters long"
  end
else
  puts "❌ SECRET_KEY_BASE environment variable is not set"
  puts "   You need to set this before deploying to production"
  puts "   Generate one with: rails secret"
end
puts

# Check 2: Old secrets.yml file
puts "2. Checking for old secrets.yml file..."
secrets_file = File.join(Dir.pwd, 'config', 'secrets.yml')
if File.exist?(secrets_file)
  content = File.read(secrets_file)
  if content.strip.empty? || content.include?('# This file is kept for Rails compatibility')
    puts "✅ config/secrets.yml exists but is properly migrated (empty/placeholder)"
  else
    puts "⚠️  config/secrets.yml still contains configuration"
    puts "   Consider reviewing if these settings have been migrated to environment variables"
  end
else
  puts "✅ config/secrets.yml has been removed (good!)"
end
puts

# Check 3: New settings configuration
puts "3. Checking new settings configuration..."
settings_file = File.join(Dir.pwd, 'config', 'settings.yml')
if File.exist?(settings_file)
  puts "✅ config/settings.yml exists for new configuration system"
else
  puts "❌ config/settings.yml is missing"
end

production_settings = File.join(Dir.pwd, 'config', 'settings', 'production.yml')
if File.exist?(production_settings)
  puts "✅ config/settings/production.yml exists"
else
  puts "⚠️  config/settings/production.yml is missing"
end
puts

# Check 4: Rails environment loading
puts "4. Checking Rails configuration loading..."
begin
  require_relative '../config/environment'
  
  # Check if secret_key_base is accessible
  if Rails.application.secret_key_base
    puts "✅ Rails.application.secret_key_base is accessible"
  else
    puts "❌ Rails.application.secret_key_base is not accessible"
  end
  
  # Check if Setting is accessible
  if defined?(Setting)
    puts "✅ Setting class is loaded"
    if Setting.respond_to?(:url)
      puts "✅ Setting.url is accessible: #{Setting.url.host rescue 'error accessing host'}"
    else
      puts "⚠️  Setting.url is not accessible"
    end
  else
    puts "❌ Setting class is not loaded"
  end
  
rescue => e
  puts "❌ Error loading Rails environment: #{e.message}"
end
puts

# Check 5: Recommendations
puts "5. Deployment Recommendations:"
puts
puts "✅ Before deploying:"
puts "   - Ensure SECRET_KEY_BASE is set in your production environment"
puts "   - Test that the application starts successfully"
puts "   - Verify that OAuth settings work correctly"
puts
puts "✅ After deploying:"
puts "   - Check application logs for any deprecation warnings"
puts "   - Test user authentication features"
puts "   - Verify admin functions work correctly"
puts

# Check 6: Generate commands for common deployment platforms
puts "6. Platform-specific commands:"
puts
puts "For Heroku:"
puts "   heroku config:set SECRET_KEY_BASE=$(bundle exec rails secret)"
puts
puts "For Docker/Docker Compose:"
puts "   Add to your docker-compose.yml or .env file:"
puts "   SECRET_KEY_BASE=$(bundle exec rails secret)"
puts
puts "For traditional server deployment:"
puts "   export SECRET_KEY_BASE=$(bundle exec rails secret)"
puts "   # Add this to your ~/.bashrc or deployment scripts"
puts

puts "=== Migration Check Complete ==="