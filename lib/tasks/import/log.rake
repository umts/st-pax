# frozen_string_literal: true

require 'csv'

desc 'Import daily log from Access CSV at data/daily_log.csv'
namespace :import do
  task log: :environment do
    CSV.foreach('data/daily_log.csv',
                encoding: 'ISO-8859-1',
                headers: true) do |row|
      date = Date.parse row.fetch('Date:')
      user_name = row.fetch('Dispatcher:')
      if user_name.is_a? String
        last_name, first_name = user_name.split(', ')
        user = User.find_by name: [first_name, last_name].join(' ')
      end
      text = row.fetch('Notes:')
      entry = LogEntry.new user: user, text: text, created_at: date
      entry.save validate: false
    end

    puts "Created #{LogEntry.count} log entries."
    puts "#{LogEntry.count(&:valid?)} are valid."
    puts
  end
end
