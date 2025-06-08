# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Judicial Reform Foundation (JRF) website, a Ruby on Rails 5.1 application using PostgreSQL. The application serves as a content management system for articles, news, and advocacy materials related to judicial reform in Taiwan.

## Setup Commands

```bash
# Initial setup
bundle install
cp config/database.yml.default config/database.yml
cp config/config.yml.default config/config.yml

# Database setup (requires PostgreSQL running)
rake db:create db:migrate

# Run the application
rails server

# Run tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/path/to/file_spec.rb

# Database migrations
rake db:migrate
rake db:rollback
```

## Architecture Overview

### Core Models and Relationships
- **Article**: Central content model with polymorphic relationships to slides, YouTube integration, and Facebook Instant Articles support
- **Keyword**: Content categorization system with many-to-many relationship to articles
- **User**: Authentication via Devise with OAuth (Google/Facebook) and admin role system
- **Catalog/Category**: Hierarchical content organization
- **Slide**: Polymorphic association for image carousels attached to articles and keywords

### Controller Structure
- **Public controllers**: Articles, keywords, static pages with multilingual support (zh-TW default)
- **Admin namespace**: Full CRUD operations with sortable interfaces for content management
- **API namespace**: JSON endpoints using RABL templates for external integrations

### Key Features
- **CKEditor integration** for rich text editing with custom uploaders
- **Carrierwave + MiniMagick** for image processing and optimization
- **Kaminari pagination** (15 items per page default)
- **Ransack** for advanced search functionality
- **YouTube integration** with automatic ID extraction and playlist support
- **Facebook Instant Articles** content transformation
- **Social sharing** via social-share-button gem
- **Multilingual support** with i18n (Chinese Traditional default, timezone: Taipei)

### Database Considerations
- Uses PostgreSQL with proper indexes on join tables
- Articles have scopes for different content types: activities, presses, comments, epapers, books
- System articles for static pages (about, donate, privacy) identified by `system_type`
- Polymorphic slides table serves multiple content types

### View Layer
- **Slim templates** throughout the application
- **Bootstrap + custom CSS** with responsive design
- **Admin interface** with sortable lists and nested forms
- **API views** using RABL for JSON serialization

### Configuration
- Environment-specific settings via `config/config.yml`
- Custom error pages (404, 422, 500) with branded styling
- Asset pipeline with custom fonts and optimized images
- Rollbar for error tracking, Skylight for performance monitoring

## Development Notes

### Testing
- RSpec with Capybara for integration testing
- Factory Girl for test data generation
- Database Cleaner for test isolation
- SimpleCov for coverage reporting

### OAuth Setup
Configure Google and Facebook OAuth credentials in `config/config.yml` for authentication to work properly. Admin users must be manually set via Rails console.

### Content Management
Articles support multiple content types via the `kind` field. System articles are used for static pages and should have `system_type` specified.