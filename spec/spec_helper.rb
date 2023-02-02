# frozen_string_literal: true

require 'pathname'
require 'simplecov'

Pathname(__dir__).join('support').glob('**/*.rb').each { |f| require f }

SimpleCov.start 'rails' do
  maximum_coverage_drop 0.5 if ENV['CI']
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

  config.example_status_persistence_file_path = File.expand_path File.join(__dir__, 'examples.txt')

  config.disable_monkey_patching!

  config.default_formatter = config.files_to_run.one? ? 'doc' : 'progress'

  config.order = :random
  Kernel.srand config.seed

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
