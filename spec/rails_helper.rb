# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec-html-matchers'
require 'rspec/retry'
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

  config.verbose_retry = true
  config.display_try_failure_messages = true

  config.retry_callback = proc do |example|
    Capybara.reset! if example.metadata[:js]
  end

  config.before :each, type: :system do
    driven_by :rack_test
  end

  config.before :each, :js, type: :system do
    driven_by :selenium, using: :headless_chrome
  end

  config.around :each, :js, type: :system do |example|
    example.run_with_retry retry: 3
  end
end
