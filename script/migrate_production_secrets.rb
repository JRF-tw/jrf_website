#!/usr/bin/env ruby
# Production Secrets to Credentials Migration Script

require 'yaml'
require 'fileutils'

puts "=== Production Secrets to Credentials Migration ==="
puts

# Step 1: Check if production secrets.yml exists
production_secrets_path = '/path/to/your/production/config/secrets.yml'
puts "Please modify the path above to your actual production secrets.yml location"
puts "Current assumed path: #{production_secrets_path}"
puts

# For this script, we'll work with the local secrets backup
local_secrets_backup = File.join(Dir.pwd, 'config', 'secrets.yml.backup')

if File.exist?(local_secrets_backup)
  puts "Found local secrets backup: #{local_secrets_backup}"
  
  # Read the secrets
  secrets = YAML.load_file(local_secrets_backup)
  puts "Loaded secrets for environments: #{secrets.keys.join(', ')}"
  puts
  
  # Production secrets analysis
  if secrets['production']
    prod_secrets = secrets['production']
    puts "Production secrets found:"
    prod_secrets.each do |key, value|
      if value.to_s.include?('ENV')
        puts "  #{key}: #{value} (uses environment variable - good!)"
      else
        puts "  #{key}: [REDACTED] (hardcoded value - needs migration)"
      end
    end
    puts
    
    # Generate migration commands
    puts "=== Migration Steps for Production ==="
    puts
    puts "Option 1: Environment Variables (Recommended)"
    puts "Copy these commands to your production server:"
    puts
    
    prod_secrets.each do |key, value|
      next if value.to_s.include?('ENV')
      env_var_name = key.upcase
      puts "export #{env_var_name}='#{value}'"
    end
    puts
    
    puts "Option 2: Rails Credentials (More Complex)"
    puts "This requires more careful setup in production."
    puts
    
    # Generate credentials template
    credentials_template = {
      'secret_key_base' => '<%= ENV["SECRET_KEY_BASE"] %>',
    }
    
    # Add other production secrets (excluding secret_key_base)
    prod_secrets.each do |key, value|
      next if key == 'secret_key_base'
      next if value.to_s.include?('ENV')
      credentials_template[key] = value
    end
    
    puts "Credentials template (save this securely):"
    puts credentials_template.to_yaml
    puts
  end
else
  puts "⚠️  No local secrets backup found at: #{local_secrets_backup}"
  puts "Please ensure you have a backup of your production secrets.yml"
end

puts "=== Recommended Migration Process ==="
puts
puts "1. Backup your production secrets.yml:"
puts "   cp config/secrets.yml config/secrets.yml.backup.$(date +%Y%m%d)"
puts
puts "2. Extract secrets to environment variables:"
puts "   # Review your current production secrets.yml"
puts "   # For each secret, create an environment variable"
puts "   # Example: if secrets.yml has 'api_key: abc123'"
puts "   # Create: export API_KEY='abc123'"
puts
puts "3. Update your deployment configuration:"
puts "   # Add environment variables to your deployment system"
puts "   # (Docker, systemd, init scripts, etc.)"
puts
puts "4. Test the migration:"
puts "   # Start your application with new environment variables"
puts "   # Verify all functionality works"
puts
puts "5. Remove the old secrets.yml:"
puts "   # Only after confirming everything works"
puts "   # mv config/secrets.yml config/secrets.yml.migrated"
puts
puts "=== Alternative: Keep secrets.yml compatibility ==="
puts
puts "If you prefer to keep using secrets.yml temporarily:"
puts "Add this to config/application.rb:"
puts '  config.secrets = config_for(:secrets)'
puts
puts "Then replace Rails.application.secrets with Rails.configuration.secrets"
puts "in your codebase."
puts
puts "However, this is a temporary solution and should be migrated eventually."
puts

puts "=== Security Reminders ==="
puts
puts "🔒 Never commit production secrets to version control"
puts "🔒 Use environment variables or encrypted credentials"
puts "🔒 Rotate secrets if they might have been exposed"
puts "🔒 Test the migration in a staging environment first"
puts