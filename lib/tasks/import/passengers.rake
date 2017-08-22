# frozen_string_literal: true

require 'csv'

desc 'Import passengers from Access CSV at data/paxinfo.csv'
namespace :import do
  task passengers: :environment do
    CSV.foreach('data/paxinfo.csv', encoding: 'ISO-8859-1', headers: true).with_index 2 do |row, line|
      attrs = {}
      attrs[:name] = [row.fetch('firstName'), row.fetch('lastName')].join ' '
      attrs[:email] = row.fetch('email')
      attrs[:address] = [row.fetch('address'), row.fetch('apartment'),
                         row.fetch('city'),
                         "#{row.fetch('state')} #{row.fetch('zip')}"].join ', '
      attrs[:phone] = row.fetch('phone')
      attrs[:active] = row.fetch('active') == 'TRUE'
      attrs[:permanent] = true
      attrs[:created_at] = Date.parse(row.fetch('date'))
      attrs[:updated_at] = Date.parse(row.fetch('timeStamp'))
      attrs[:note] = row.fetch('Notes')
      device_name = row.fetch('mobilityDevice')
      mobility_device = MobilityDevice.find_by device: device_name
      if mobility_device.present?
        attrs[:mobility_device] = mobility_device
      else
        puts "paxinfo.csv:#{line} : Could not find mobility device #{device_name}"
      end

      passenger = Passenger.new attrs
      unless passenger.save
        puts "paxinfo.csv:#{line} : Skipping validations."
        passenger.save validate: false
      end
    end

    puts "Created #{Passenger.permanent.count} permanent passengers."
    puts "#{Passenger.permanent.count(&:valid?)} are valid."
  end
end
