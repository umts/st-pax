# frozen_string_literal: true

require 'csv'

desc 'Import dispatchers from Access CSV at data/disp.csv'
namespace :import do
  task dispatchers: :environment do
    CSV.foreach('data/disp.csv', headers: true).with_index 2 do |row, line|
      case row.fetch 'Status'
      when 'ST Coordinator', 'Student Staff'
        admin = true
      when 'ST Dispatcher', 'ST Dspatcher', 'ST Dispatcer'
        admin = false
      else
        puts "disp.csv:#{line} : Unrecognized status '#{row.fetch('Status')}'"
        next
      end
      last_name, first_name = row.fetch('dispatcher').split ', '
      name = [first_name, last_name].join ' '

      user = User.new name: name, admin: admin, active: true
      unless user.save
        puts "disp.csv:#{line} : Skipping validations."
        user.save validate: false
      end
    end

    puts "Created #{User.count} users."
    puts "#{User.count(&:valid?)} are valid."
    puts
  end
end
