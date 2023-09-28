# frozen_string_literal: true

require 'csv'

namespace :users do
  desc 'Export User Spire IDs to CSV for AD lookup/processing'
  task export_spires: :environment do
    path = Rails.root.join "private/users-#{Date.today}.csv"
    CSV.open(path, 'w', headers: %w[id spire_id], write_headers: true) do |csv|
      User.where(net_id: [nil, '']).where.not(spire: [nil, '']).find_each do |user|
        csv << [user.id, user.spire.split('@').first]
      end
    end
  end

  desc 'Import User NetIDs and AD UIDs'
  task :import_netids, [:filename] => [:environment] do |_task, args|
    CSV.foreach Rails.root.join('private', args[:filename]), headers: true do |row|
      User.find(row['id']).update!(net_id: row['net_id'], uid: row['uid'])
    end
  end
end
