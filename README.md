# Judicial Reform Foundation Website

[![Build Status](https://travis-ci.org/JRF-tw/jrf_website.svg?branch=master)](https://travis-ci.org/JRF-tw/jrf_website)

## Rails Version

This project has been upgraded to **Rails 7.1** with **Rails 7.2 compatibility**. 

### Recent Upgrades (2025-06)
- ✅ Rails 7.1.5.1 with Rails 7.2 forward compatibility
- ✅ Bootstrap 5.3 via gem (replaced vendor CSS)
- ✅ Migrated from deprecated `secrets.yml` to Rails credentials system
- ✅ Updated Devise integration and admin authentication
- ✅ Fixed all controller parameter handling for Rails 7.1
- ✅ Comprehensive test suite passing (138+ examples)

## Project Setup

### Prerequisites
- Ruby 3.2.8+ 
- PostgreSQL
- Node.js (for asset compilation)

### Initial Setup

```bash
# Install dependencies
bundle install

# Copy configuration templates
cp config/database.yml.default config/database.yml
cp config/config.yml.default config/config.yml
```

### Database Setup

```bash
# Create and migrate database
rake db:create db:migrate

# Start the application
rails server
```

### Admin Setup

1. Setup Google or Facebook OAuth login in `config/config.yml`
2. Create admin user via Rails console:
   ```ruby
   user = User.find_by(email: 'your@email.com')
   user.update(admin: true)
   ```

### Testing

```bash
# Run full test suite
bundle exec rspec

# Run specific test categories
bundle exec rspec spec/models/
bundle exec rspec spec/requests/admin/
```

## PostgreSql

- install

```
brew install postgresql
brew unlink postgresql
brew link postgresql
ARCHFLAGS="-arch x86_64" gem install pg
```

- goto http://postgresapp.com/ download and start it.

- setup user & password

```
psql
```

- replace your_name & your_password

```
CREATE USER your_name WITH PASSWORD 'your_password';
CREATE DATABASE "your_name";
GRANT ALL PRIVILEGES ON DATABASE "your_name" to "your_name";
ALTER USER "your_name" WITH SUPERUSER;
```

## LICENSE
This project is release under MIT License.


