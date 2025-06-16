# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the Judicial Reform Foundation (JRF) website, a **Ruby on Rails 7.1** application using PostgreSQL. The application serves as a content management system for articles, news, and advocacy materials related to judicial reform in Taiwan.

### Recent Rails 7.1 Upgrade (2025-06)

The application has been successfully upgraded from Rails 5.1 to Rails 7.1 with forward compatibility for Rails 7.2:

#### ✅ Core Upgrades Completed
- **Rails 7.1.5.1** with Rails 7.2 compatibility
- **Bootstrap 5.3** via gem (replaced vendor CSS files)
- **Credentials System**: Migrated from deprecated `secrets.yml` to Rails credentials
- **Controller Updates**: Fixed parameter handling for Rails 7.1 strong parameters
- **Authentication**: Updated Devise integration and admin authentication
- **Test Suite**: Comprehensive test coverage with 138+ passing examples

#### 🔐 Security & Configuration Updates
- **Encrypted Credentials**: Environment-specific credentials files for secure secret management
- **Environment Variables**: Production-ready configuration using `SECRET_KEY_BASE` and `RAILS_MASTER_KEY`
- **Backward Compatibility**: Existing production deployments continue working without changes

#### 📋 Migration Documentation
- See `script/secrets_to_credentials_migration_guide.md` for detailed migration instructions
- Production deployment guide for secret management transition
- Environment-specific credential setup and validation procedures

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
- **Rails Credentials**: Environment-specific encrypted credentials for secure secret management
- **Environment Settings**: Configuration via `config/config.yml` for non-sensitive settings
- **Custom Error Pages**: Branded 404, 422, 500 error pages with responsive design
- **Asset Pipeline**: Optimized with Bootstrap 5.3 gem and custom fonts
- **Monitoring**: Rollbar for error tracking, Skylight for performance monitoring
- **Production Deployment**: Uses `SECRET_KEY_BASE` and `RAILS_MASTER_KEY` environment variables

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

## Rails 7.1 Specific Notes

### Credentials Management
- **Development/Test**: Uses local key files in `config/credentials/[environment].key`
- **Production**: Uses `RAILS_MASTER_KEY` environment variable
- **Migration**: See `script/secrets_to_credentials_migration_guide.md` for full production migration guide

### Controller Changes
- All admin controllers updated for Rails 7.1 parameter handling
- Fixed callback configurations (removed non-existent action references)
- Updated nested attributes and sorting functionality

### Asset Management
- Bootstrap 5.3 integrated via gem instead of vendor CSS
- Resolved SCSS compilation issues with custom properties
- Maintained custom styling compatibility

### Testing Framework
- Updated RSpec configuration for Rails 7.1
- Fixed fixture path deprecation warnings
- All admin and model tests passing (138+ examples)
- Updated authentication helpers for Devise integration

### Deployment Considerations
- Backward compatible with existing production secrets
- Gradual migration path available
- Environment variable fallbacks maintained
- Production deployment requires no immediate changes