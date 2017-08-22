# frozen_string_literal: true

require 'csv'

desc 'Import mobility devices from Access CSV at data/mobilitydevice.csv'
namespace :import do
  task mobility_devices: :environment do
    CSV.foreach('data/mobilitydevice.csv', encoding: 'ISO-8859-1:UTF-8', headers: true).with_index 2 do |row, line|
      device = MobilityDevice.new device: row.fetch('name'),
                                  access_id: row.fetch('id')
      unless device.save
        puts "mobilitydevice.csv:#{line} : Skipping validations."
        device.save validate: false
      end
    end

    puts "Created #{MobilityDevice.count} mobility devices."
    puts "#{MobilityDevice.count(&:valid?)} are valid."
    puts
  end
end