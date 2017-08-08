require 'ffaker'

5.times do
  User.create! name: FFaker::Name.name,
               email: FFaker::Internet.email,
               phone: FFaker::PhoneNumber.short_phone_number,
               spire: rand(10**8).to_s.rjust(8, '0'),
               active: true,
               admin: false
end

2.times do
  User.create! name: FFaker::Name.name,
               email: FFaker::Internet.email,
               phone: FFaker::PhoneNumber.short_phone_number,
               spire: rand(10**8).to_s.rjust(8, '0'),
               active: true,
               admin: true
end
