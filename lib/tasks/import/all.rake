# frozen_string_literal: true

desc 'Run all import tasks from CSV files'
namespace :import do
  task all: %i[
    dispatchers
    mobility_devices
  ]
end
