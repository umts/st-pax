require 'ffaker'
expirations = ((Date.today - 7.days)..(Date.today + 6.months)).to_a

20.times do
  [nil, Date.today + 2.days, Date.today - 2.days, Date.today - 4.days, expirations.sample].each do |exp|
    Passenger.create! name: FFaker::Name.name,
                      address: FFaker::Address.street_address,
                      email: FFaker::Internet.email,
                      phone: FFaker::PhoneNumber.short_phone_number,
                      wheelchair: [true, false].sample,
                      active: true,
                      permanent: [true, false].sample,
                      expiration: exp
  end
end

User.create! name: 'David Faulkenberry',
             email: 'dave@example.com',
             spire: '12345678@umass.edu',
             admin: true
