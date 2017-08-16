require 'factory_girl'
include FactoryGirl::Syntax::Methods

2.times { create :user, :admin }

5.times { create :user }

50.times { create :passenger, :permanent }
50.times { create :passenger, :recently_expired }
50.times { create :passenger, :expiring_soon }
50.times { create :passenger, :expiration_overriden }
50.times { create :passenger, :inactive }
5.times  { create :passenger, :no_note }
