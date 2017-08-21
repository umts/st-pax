# frozen_string_literal: true

require 'csv'

desc 'Import passengers from Access CSV at data/paxinfo.csv'
namespace :import do
  task passengers: :environment do
    CSV.foreach('data/paxinfo.csv', encoding: 'ISO-8859-1', headers: true).with_index 2 do |row, index|
      attrs = {}
      attrs[:name] = [row.fetch('firstName'), row.fetch('lastName')].join ' '
      attrs[:email] = row.fetch('email')
      attrs[:address] = [row.fetch('address'), row.fetch('apartment'),
                         row.fetch('city'),
                         "#{row.fetch('state')} #{row.fetch('zip')}"].join ', '
      attrs[:phone] = row.fetch('phone')
      binding.pry
    end
  end
end
