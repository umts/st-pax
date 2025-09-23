# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'bootstrap_form', '~> 5.4'
gem 'business_time'
gem 'cssbundling-rails'
gem 'csv'
gem 'exception_notification'
gem 'faraday-retry'
gem 'haml'
gem 'haml-rails'
gem 'irb'
gem 'kaminari'
gem 'mysql2'
gem 'octokit'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails', '~> 8.0.3'
gem 'rake'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'turbo-rails'

group :development, :test do
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara'
  gem 'rack_session_access'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'selenium-webdriver'
end

group :development do
  gem 'bcrypt_pbkdf', require: false
  gem 'brakeman', require: false
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', require: false
  gem 'haml-lint'
  gem 'listen'
  gem 'overcommit', require: false
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :production do
  gem 'terser'
end
