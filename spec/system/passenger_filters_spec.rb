# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passenger Filters' do
  before :each do
    when_current_user_is :admin
  end

  context 'html view', js: true do
    it 'allows filtering by permanent status' do
      create :temporary_passenger, name: 'Gary Stue'
      create :passenger, :permanent, name: 'Mary Sue'
      visit passengers_url
      choose 'Permanent'
      expect(page).to have_selector 'table#passengers tbody tr', count: 1
      expect(page).to have_content 'Mary Sue'
      expect(page).not_to have_content 'Gary Stue'
    end

    it 'allows filtering by temporary' do
      create :passenger, :permanent, name: 'Mary Sue'
      create :temporary_passenger, name: 'Gary Stue'
      visit passengers_url
      choose 'Temporary'
      expect(page).to have_selector 'table#passengers tbody tr', count: 1
      expect(page).not_to have_content 'Mary Sue'
      expect(page).to have_content 'Gary Stue'
    end

    it 'allows filtering by everyone' do
      create :temporary_passenger, name: 'Gary Stue'
      create :passenger, :permanent, name: 'Mary Sue'
      visit passengers_url
      choose 'All'
      expect(page).to have_selector 'table#passengers tbody tr', count: 2
      expect(page).to have_content 'Mary Sue'
      expect(page).to have_content 'Gary Stue'
    end
  end

  it 'allows printing a PDF with filters' do
    create :passenger, :permanent, name: 'Spongebob'
    visit passengers_url
    choose 'Permanent'
    click_on 'Print'

    analysis = PDF::Inspector::Text.analyze(page.body)
    expect(analysis.strings).to include 'Name'
    expect(analysis.strings).to include 'Spongebob'
  end
end
