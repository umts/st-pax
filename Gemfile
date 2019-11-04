# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootstrap', '~> 4.3.1'
gem 'business_time'
gem 'coffee-rails', '~> 4.2'
gem 'exception_notification'
gem 'haml'
gem 'haml-rails'
gem 'mysql2'
gem 'prawn'
gem 'prawn-table'
gem 'rails', '~> 5.1'
gem 'rake'
gem 'sassc-rails'
gem 'turbolinks', '~> 5'
gem 'will_paginate', '~> 3.1'
gem 'puma'

group :development, :test do
  gem 'codeclimate-test-reporter'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
  gem 'selenium-webdriver'
  gem 'rack_session_access'
  gem 'rspec-rails'
  gem 'rspec-html-matchers'
  gem 'timecop'
end

group :development do
  gem 'capistrano', '~> 3.9.0', require: false
  gem 'capistrano-bundler',     require: false
  gem 'capistrano-passenger',   require: false
  gem 'capistrano-pending',     require: false
  gem 'capistrano-rails',       require: false
  gem 'capistrano-yarn',        require: false
  gem 'erb2haml'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rb-fsevent', '0.9.8'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'uglifier'
end
