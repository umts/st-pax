# frozen_string_literal: true

require 'factory_girl'
include FactoryGirl::Syntax::Methods
require 'timecop'

2.times { create :user, :admin }

5.times { create :user }

20.times { create :passenger, :permanent }
20.times { create :passenger, :temporary }

5.times { create :passenger, :temporary, :expired_within_grace_period }
5.times { create :passenger, :temporary, :expiring_soon }
5.times { create :passenger, :temporary, :expiration_overriden }
5.times { create :passenger, :temporary, :inactive }
5.times  { create :passenger, :temporary, :no_note }

dispatchers = User.dispatchers
30.times do
  Timecop.freeze 1.month.ago + rand(1.month) do
    create :log_entry, user: dispatchers.sample
  end
end
