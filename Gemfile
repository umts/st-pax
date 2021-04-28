# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootstrap', '~> 4.3'
gem 'bootstrap_form'
gem 'business_time'
gem 'exception_notification'
gem 'figaro'
gem 'haml'
gem 'haml-rails'
gem 'mysql2'
gem 'octokit'
gem 'prawn'
gem 'prawn-table'
gem 'puma'
gem 'rails', '~> 6.1.3'
gem 'rake'
gem 'sassc-rails'
gem 'turbolinks', '~> 5'
gem 'will_paginate', '~> 3.1'
gem 'will_paginate-bootstrap4'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pdf-inspector', require: 'pdf/inspector'
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'simplecov', require: false
end

group :test do
  gem 'capybara'
  gem 'rack_session_access'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'webdrivers'
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
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rb-fsevent', '0.9.8'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :production do
  gem 'uglifier'
end
