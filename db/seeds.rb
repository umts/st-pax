# frozen_string_literal: true

require 'factory_bot'
require 'timecop'

module SeedCreator
  class << self
    include FactoryBot::Syntax::Methods

    def create_users
      create_list :user, 2, :admin
      create_list :user, 5
    end

    def create_mobility_devices
      %w[Cane Crutches Wheelchair].each do |name|
        create :mobility_device, name: name
      end
    end

    def create_passengers
      create_list :passenger, 20, :permanent
      create_list :passenger, 20, :temporary, :with_note

      create_list :passenger, 5, :temporary, :expired_within_grace_period
      create_list :passenger, 5, :temporary, :expiring_soon
      create_list :passenger, 5, :temporary, :expiration_overridden
      create_list :passenger, 5, :temporary, :inactive
      create_list :passenger, 5, :temporary, :no_note
    end

    def create_dispatch_logs
      dispatchers = User.dispatchers
      300.times do
        Timecop.freeze 12.months.ago + rand(12.months) do
          create :log_entry, user: dispatchers.sample
        end
      end
    end
  end
end

SeedCreator.create_users
SeedCreator.create_mobility_devices
SeedCreator.create_passengers
SeedCreator.create_dispatch_logs
