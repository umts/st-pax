# frozen_string_literal: true

require 'factory_girl'
include FactoryGirl::Syntax::Methods
require 'timecop'

2.times { create :user, :admin }

5.times { create :user }

20.times { create :passenger, :permanent }
20.times { create :passenger, :recently_expired }
20.times { create :passenger, :expiring_soon }
20.times { create :passenger, :expiration_overriden }
20.times { create :passenger, :inactive }
5.times  { create :passenger, :no_note }

dispatchers = User.dispatchers
30.times do
  Timecop.freeze 1.month.ago + rand(1.month) do
    create :log_entry, user: dispatchers.sample
  end
end
