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
      create_list :passenger, 5, :permanent,
        active_status: ['active', 'pending'].sample,
        verification: nil
      create_list :passenger, 5, :permanent,
        active_status:['active', 'pending'].sample,
        verification: create_verification
      create_list :passenger, 5, :temporary, active_status: 'pending',
        verification: nil
      create_list :passenger, 5, :temporary, verification: create_verification
      create_list :passenger, 5, :temporary, :active,
        verification: create_verification(expires: 2.business_days.ago)
      create_list :passenger, 5, :temporary, :active,
        verification: create_verification(expires: 6.days.from_now)
      create_list :passenger, 3, :temporary, :active,
        verification: create_verification(expires: 1.month.ago)
    end

    def create_verification(expires: nil)
      source = VerificationSource.all.sample || create(:verification_source)
      create :verification, verification_source: source, expiration_date: expires
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
