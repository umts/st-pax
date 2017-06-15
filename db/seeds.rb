# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'ffaker'
expirations = ((Date.today - 7.days)..(Date.today + 6.months)).to_a

10.times do
  Passenger.create! name: FFaker::Name.name,
                    address: FFaker::Address.street_address,
                    email: FFaker::Internet.email,
                    phone: FFaker::PhoneNumber.short_phone_number,
                    wheelchair: false,
                    active: true,
                    permanent: false,
                    expiration: expirations.sample
  Passenger.create! name: FFaker::Name.name,
                    address: FFaker::Address.street_address,
                    email: FFaker::Internet.email,
                    phone: FFaker::PhoneNumber.short_phone_number,
                    wheelchair: false,
                    active: true,
                    permanent: true
end

Passenger.create! name: FFaker::Name.name,
                  address: FFaker::Address.street_address,
                  email: FFaker::Internet.email,
                  phone: FFaker::PhoneNumber.short_phone_number,
                  wheelchair: true,
                  active: true,
                  permanent: false
Passenger.create! name: FFaker::Name.name,
                  address: FFaker::Address.street_address,
                  email: FFaker::Internet.email,
                  phone: FFaker::PhoneNumber.short_phone_number,
                  wheelchair: false,
                  active: true,
                  permanent: false
Passenger.create! name: FFaker::Name.name,
                  address: FFaker::Address.street_address,
                  email: FFaker::Internet.email,
                  phone: FFaker::PhoneNumber.short_phone_number,
                  wheelchair: false,
                  active: true,
                  permanent: false,
                  expiration: '2017-06-13'
