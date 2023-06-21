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

  describe 'POST /log' do
    subject(:submit) { post '/log', params: { log_entry: attributes } }

    let(:attributes) { {} }

    context 'when not logged in' do
      it 'responds with an unauthorized status' do
        submit
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new log entry' do
        expect { submit }.not_to change(LogEntry, :count)
      end
    end

    context 'when logged in as a passenger' do
      before { login_as_passenger create(:passenger) }

      it 'responds with an unauthorized status' do
        submit
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not create a new log entry' do
        expect { submit }.not_to change(LogEntry, :count)
      end
    end

    context 'when logged in as a normal user' do
      before { login_as create(:user) }

      context 'with valid attributes' do
        let(:attributes) { { text: 'Test log entry' } }

        it 'responds with a redirect to all log entries' do
          submit
          expect(response).to redirect_to(log_entries_path)
        end

        it 'creates a new log entry' do
          expect { submit }.to change(LogEntry, :count).by(1)
        end

        it 'creates a new log entry with the given attributes' do
          submit
          expect(LogEntry.last).to have_attributes(attributes)
        end
      end

      context 'with invalid attributes' do
        let(:attributes) { { text: '' } }

        it 'responds with a redirect to all log entries' do
          submit
          expect(response).to redirect_to(log_entries_path)
        end

        it 'does not create a new log entry' do
          expect { submit }.not_to change(LogEntry, :count)
        end
      end

      context 'with a pinned attribute' do
        let(:attributes) { { text: 'Test log entry', pinned: true } }

        it 'creates a new log entry' do
          expect { submit }.to change(LogEntry, :count).by(1)
        end

        it 'ignores the given pinned attribute' do
          submit
          expect(LogEntry.last).not_to be_pinned
        end
      end
    end

    context 'when logged in as an administrator' do
      before { login_as create(:user, :admin) }

      context 'with a pinned attribute' do
        let(:attributes) { { text: 'Test log entry', pinned: true } }

        it 'creates a new log entry' do
          expect { submit }.to change(LogEntry, :count).by(1)
        end

        it 'accepts the given pinned attribute' do
          submit
          expect(LogEntry.last).to be_pinned
        end
      end
    end
  end
end
