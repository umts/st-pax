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
      create_list :passenger, 5, :permanent
      create_list :passenger, 5, :permanent, :unverified, :active
      create_list :passenger, 5, :temporary, :unverified
      create_list :passenger, 5, :temporary, :active, :verified
      create_list :passenger, 5, :temporary, :active, :expired_within_grace_period
      create_list :passenger, 5, :temporary, :active, :expiring_soon
      create_list :passenger, 5, :temporary, :active, :expired
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

%w[UHS Disability\ Services Accessible\ Workplace].each do |name|
  VerificationSource.find_or_create_by(name: name)
end

SeedCreator.create_users
SeedCreator.create_mobility_devices
SeedCreator.create_passengers
SeedCreator.create_dispatch_logs
