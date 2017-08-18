# frozen_string_literal: true

require 'csv'

desc 'Import dispatchers from Access CSV at data/disp.csv'
namespace :import do
  task dispatchers: :environment do
    CSV.foreach 'data/disp.csv', headers: true do |row|
      binding.pry
    end
  end
end
