# frozen_string_literal: true

require 'factory_bot'
include FactoryBot::Syntax::Methods
require 'timecop'

2.times { create :user, :admin }

5.times { create :user }

%w[Cane Crutches Wheelchair].each do |name|
  create :mobility_device, name: name
end

20.times { create :passenger, :permanent }
20.times { create :passenger, :temporary, :with_note }

5.times { create :passenger, :temporary, :expired_within_grace_period }
5.times { create :passenger, :temporary, :expiring_soon }
5.times { create :passenger, :temporary, :expiration_overridden }
5.times { create :passenger, :temporary, :inactive }
5.times { create :passenger, :temporary, :no_note }

dispatchers = User.dispatchers
300.times do
  Timecop.freeze 12.months.ago + rand(12.months) do
    create :log_entry, user: dispatchers.sample
  end
end
