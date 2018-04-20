# frozen_string_literal: true

require 'rails_helper'

feature 'Passenger Filters' do
  before :each do
    when_current_user_is :admin
  end
  scenario 'permanent filter' do
    create :passenger, :temporary, name: 'Gary Stue'
    create :passenger, :permanent, name: 'Mary Sue'
    visit passengers_url
    choose 'Permanent Only'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 1
    expect(page).to have_content 'Mary Sue'
    expect(page).not_to have_content 'Gary Stue'
  end
  scenario 'temporary filter' do
    create :passenger, :permanent, name: 'Mary Sue'
    create :passenger, :temporary, name: 'Gary Stue'
    visit passengers_url
    choose 'Temporary Only'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 1
    expect(page).not_to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  scenario 'all filter' do
    create :passenger, :temporary, name: 'Gary Stue'
    create :passenger, :permanent, name: 'Mary Sue'
    visit passengers_url
    choose 'All'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 2
    expect(page).to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  scenario 'active filter' do
    create :passenger, name: 'Gary Stue'
    create :passenger, :inactive, name: 'Mary Sue'
    visit passengers_url
    uncheck 'Show Inactive'
    click_on 'Show Passengers'
    expect(page).to have_selector 'table#passengers tbody tr', count: 1
    expect(page).not_to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  scenario 'inactive filter' do
    create :passenger, name: 'Gary Stue'
    create :passenger, :inactive, name: 'Mary Sue'
    visit passengers_url
    check 'Show Inactive'
    click_on 'Show Passengers'
    # Shows both active and inactive passengers
    expect(page).to have_selector 'table#passengers tbody tr', count: 2
    expect(page).to have_content 'Mary Sue'
    expect(page).to have_content 'Gary Stue'
  end
  scenario 'Printing a PDF' do
    visit passengers_url
    choose 'Permanent Only'
    create :passenger, :permanent, name: 'Spongebob'
    click_on 'Print This Page'
    analysis = PDF::Inspector::Text.analyze(page.body)
    expect(analysis.strings).to include 'Name'
    expect(analysis.strings).to include 'Permanent Active Passengers 04/20/2018'
    expect(analysis.strings).to include 'Spongebob'
  end
end
