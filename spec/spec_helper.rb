# frozen_string_literal: true

require 'pathname'
require 'simplecov'

Pathname(__dir__).join('support').glob('**/*.rb').each { |f| require f }

SimpleCov.start 'rails' do
  refuse_coverage_drop
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  else
    config.default_formatter = 'progress'
  end

  config.order = :random
  Kernel.srand config.seed

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
