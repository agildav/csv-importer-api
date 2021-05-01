source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 4.1'

gem 'activerecord-import', '~> 1.0.6'
gem 'activerecord-reset-pk-sequence', '~> 0.2.1'
gem 'delayed_job_active_record', '~> 4.1.4'
gem 'active_model_serializers', '~> 0.10.10'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'will_paginate', '~> 3.3'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'colorize', '~> 0.8.1'
# Cloudinary, for file storage
gem 'cloudinary', '~> 1.16.1'
gem 'bcrypt', '~> 3.1.13'
# Credit card validators
gem 'credit_card_validator', '~> 1.3', '>= 1.3.2'
gem 'faker', '~> 2.14'
gem 'simple_command', '~> 0.1.0'
gem 'pg_search', '~> 2.3', '>= 2.3.5'

group :development, :test do
  gem 'annotate'
  gem 'pry-byebug'
  gem 'sql_queries_count'
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'simplecov-console'
  gem 'bullet'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
