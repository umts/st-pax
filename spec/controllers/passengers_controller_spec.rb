# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengersController do
  before do
    when_current_user_is :admin
  end

  let(:passenger) { create(:passenger, :permanent) }
  let(:mail_exception) { Net::SMTPFatalError.new 'It Broke!' }

  describe 'POST set_status' do
    context 'with broken mailer' do
      # Deliberate to avoid triggering the stubbed exceptions outside of the example
      # rubocop:disable Rails/SkipsModelValidations
      before do
        allow(PassengerMailer).to receive(:notify_archived).and_raise mail_exception
        allow(PassengerMailer).to receive(:notify_active).and_raise mail_exception
      end

      context 'when changing active to archived' do
        before do
          passenger.update_columns registration_status: 'active'
          post :set_status, params: { id: passenger.id, status: 'archived' }
        end

        it 'saves the passenger' do
          expect(passenger.reload.registration_status).to eq 'archived'
        end

        it 'redirects to the index' do
          expect(response).to redirect_to(passengers_path)
        end

        it 'displays a warning message' do
          expect(flash[:warning]).to match(/email followup was unsuccessful/)
        end
      end

      context 'when changing archived to active' do
        before do
          passenger.update_columns registration_status: 'archived'
          post :set_status, params: { id: passenger.id, status: 'active' }
        end

        it 'saves the passenger' do
          expect(passenger.reload.registration_status).to eq 'active'
        end

        it 'redirects to the index' do
          expect(response).to redirect_to(passengers_path)
        end

        it 'displays a warning message' do
          expect(flash[:warning]).to match(/email followup was unsuccessful/)
        end
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  describe 'POST create' do
    context 'with broken mailer' do
      before do
        allow(PassengerMailer).to receive(:notify_pending).and_raise mail_exception
      end

      context 'when creating a pending passenger' do
        before do
          post :create, params: new_passenger_params
        end

        let(:new_passenger_params) { { passenger: attributes_for(:passenger, :permanent) } }
        let(:created_passenger) { Passenger.find_by(name: new_passenger_params[:passenger][:name]) }

        it 'saves the passenger' do
          expect(created_passenger).to be_present
        end

        it 'redirects to the passenger' do
          expect(response).to redirect_to(passenger_path(created_passenger))
        end

        it 'displays a warning message' do
          expect(flash[:warning]).to match(/email followup was unsuccessful/)
        end
      end
    end
  end

  describe 'POST update' do
    context 'with broken mailer' do
      # Deliberate to avoid triggering the stubbed exceptions outside of the example
      # rubocop:disable Rails/SkipsModelValidations
      before do
        allow(PassengerMailer).to receive(:notify_archived).and_raise mail_exception
        allow(PassengerMailer).to receive(:notify_active).and_raise mail_exception
      end

      context 'when changing active to archived' do
        before do
          passenger.update_columns registration_status: 'active'
          post :update, params: { id: passenger.id, passenger: { registration_status: 'archived' } }
        end

        it 'saves the passenger' do
          expect(passenger.reload.registration_status).to eq 'archived'
        end

        it 'redirects to the passenger' do
          expect(response).to redirect_to(passenger_path(passenger))
        end

        it 'displays a warning message' do
          expect(flash[:warning]).to match(/email followup was unsuccessful/)
        end
      end

      context 'when changing archived to active' do
        before do
          passenger.update_columns registration_status: 'archived'
          post :update, params: { id: passenger.id, passenger: { registration_status: 'active' } }
        end

        it 'saves the passenger' do
          expect(passenger.reload.registration_status).to eq 'active'
        end

        it 'redirects to the passenger' do
          expect(response).to redirect_to(passenger_path(passenger))
        end

        it 'displays a warning message' do
          expect(flash[:warning]).to match(/email followup was unsuccessful/)
        end
      end
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
