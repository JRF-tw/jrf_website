#!/usr/bin/env ruby

# Simple test runner to check syntax and basic functionality
puts "Checking test file syntax..."

test_files = [
  'spec/models/article_spec.rb',
  'spec/models/user_spec.rb', 
  'spec/models/keyword_spec.rb',
  'spec/models/site_spec.rb',
  'spec/models/setting_spec.rb'
]

test_files.each do |file|
  if File.exist?(file)
    result = `ruby -c #{file} 2>&1`
    if $?.success?
      puts "✓ #{file} - Syntax OK"
    else
      puts "✗ #{file} - Syntax Error: #{result}"
    end
  else
    puts "✗ #{file} - File not found"
  end
end

puts "\nChecking factory files..."
factory_files = Dir['spec/factories/*.rb']
factory_files.each do |file|
  result = `ruby -c #{file} 2>&1`
  if $?.success?
    puts "✓ #{file} - Syntax OK"
  else
    puts "✗ #{file} - Syntax Error: #{result}"
  end
end

puts "\nTest syntax check completed!"