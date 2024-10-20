source "https://rubygems.org"

ruby "3.2.2"
gem "rails", "~> 7.2.1"

gem 'bootsnap', require: false
gem 'puma', '>= 5.0'

gem 'dotenv'
gem 'pg', '~> 1.5'
gem 'redis', "~> 5.3"
gem 'sidekiq', "~> 7.3.2"
gem 'factory_bot_rails'
gem 'faker'

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'rspec-rails', require: false
  gem 'database_cleaner-active_record'
end
