# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  refuse_coverage_drop
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def when_current_user_is(user)
  current_user =
    case user
    when Symbol then create :user, user
    when User then user
    when nil then nil
    else raise ArgumentError, 'Invalid user type'
    end
  login_as current_user
end

def login_as(user)
  page.set_rack_session(user_id: user.id)
end
