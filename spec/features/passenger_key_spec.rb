# frozen_string_literal: true

require 'rails_helper'

feature 'Passenger Keys' do
  before :each do
    when_current_user_is :admin
  end
  scenario 'will expire in a week' do
    create :passenger, :expiring_soon
    visit passengers_url
    expect(page).to have_css('tr.will_expire_soon')
  end
  scenario 'recently expired' do
    create :passenger, :expired_within_grace_period
    visit passengers_url
    expect(page).to have_css('tr.expired_within_grace_period')
  end
  scenario 'No Note' do
    create :passenger
    visit passengers_url
    expect(page).to have_css('tr.no_note')
  end
end
