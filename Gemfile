# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'bootstrap', '~> 4.3'
gem 'bootstrap_form'
gem 'business_time'
gem 'exception_notification'
gem 'haml'
gem 'haml-rails'
gem 'kaminari'
gem 'matrix'
gem 'mysql2'
gem 'octokit'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails', '~> 7.0.8'
gem 'rake'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'turbolinks', '~> 5'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-byebug'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara'
  gem 'rack_session_access'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'timecop'
end

group :development do
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0', require: false
  gem 'capistrano', '~> 3.14',           require: false
  gem 'capistrano-bundler',              require: false
  gem 'capistrano-passenger',            require: false
  gem 'capistrano-pending',              require: false
  gem 'capistrano-rails',                require: false
  gem 'ed25519', '>= 1.2', '< 2.0',      require: false
  gem 'erb2haml'
  gem 'haml-lint'
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'uglifier'
end
