# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Log Entries' do
  describe 'GET /log' do
    subject(:call) { get '/log' }

    context 'when not logged in' do
      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger create(:passenger) }

      it 'responds with an unauthorized status' do
        call
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in as a normal user' do
      before { login_as create(:user) }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end

    context 'when logged in as an administrator' do
      before { login_as create(:user, :admin) }

      it 'responds successfully' do
        call
        expect(response).to be_successful
      end
    end
  end
end
