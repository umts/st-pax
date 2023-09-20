# frozen_string_literal: true

require 'csv'

namespace :passengers do
  desc 'Export Passenger Spire IDs to CSV for AD lookup/processing'
  task export_spires: :environment do
    path = Rails.root.join "private/passengers-#{Date.today}.csv"
    CSV.open(path, 'w', headers: %w[id spire_id], write_headers: true) do |csv|
      Passenger.where(net_id: [nil, '']).where.not(spire: [nil, '']).find_each do |passenger|
        csv << [passenger.id, passenger.spire.split('@').first]
      end
    end
  end

  desc 'Import Passenger NetIDs and AD UIDs'
  task :import_netids, [:filename] => [:environment] do |_task, args|
    CSV.foreach Rails.root.join('private', args[:filename]), headers: true do |row|
      Passenger.find(row['id']).update!(net_id: row['net_id'], uid: row['uid'])
    end
  end
end
