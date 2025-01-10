# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Mobility Devices' do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:pax) { create(:passenger) }

  describe 'GET /index' do
    subject(:call) { get '/mobility_devices' }

    context 'when logged in as admin' do
      before { login_as admin }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      before { login_as user }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger pax }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe 'GET /new' do
    subject(:call) { get '/mobility_devices/new' }

    context 'when logged in as admin' do
      before { login_as admin }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as a user' do
      before { login_as user }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger pax }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status :unauthorized
      end
    end
  end
end
