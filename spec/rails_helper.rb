# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec-html-matchers'
require 'capybara/rspec'
require 'capybara/rails'
require 'rack_session_access/capybara'
require 'selenium/webdriver'
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.before :each, type: :system do
    driven_by :rack_test
  end
  config.before :each, :js, type: :system do
    driven_by :selenium_chrome_headless
  end
end
