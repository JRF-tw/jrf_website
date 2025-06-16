// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Import jQuery and related libraries
import "jquery"
import "jquery_ujs"
import "bootstrap"

// Initialize application
document.addEventListener('DOMContentLoaded', function() {
  // Your application initialization code here
  console.log("Rails 7 application loaded");
});