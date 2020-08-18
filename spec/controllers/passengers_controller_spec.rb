# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengersController do

  let!(:admin) { create :user, :admin }
  before :each do
    session[:user_id] = admin.id
  end

  describe 'POST set_status' do
    context 'with broken mailer' do
      context 'changing active to archived' do
        it 'saves the passenger and displays a warning message' do
          allow(PassengerMailer).to receive(:notify_archived).and_raise Net::SMTPFatalError

          @passenger = create :passenger, :permanent, active_status: 'active'
          post :set_status, params: { id: @passenger.id, status: 'archived' }
          @passenger.reload

          expect(@passenger.active_status).to eq 'archived'
          expect(response).to redirect_to(passengers_path)
          expect(flash[:warning]).to match(/the passenger was unable to be notified of their status change via email/)
        end
      end
      context 'changing archived to active' do
        it 'saves the passenger and displays a warning message' do
          allow(PassengerMailer).to receive(:notify_active).and_raise Net::SMTPFatalError

          @passenger = create :passenger, :permanent, active_status: 'archived'
          post :set_status, params: { id: @passenger.id, status: 'active' }
          @passenger.reload

          expect(@passenger.active_status).to eq 'active'
          expect(response).to redirect_to(passengers_path)
          expect(flash[:warning]).to match(/the passenger was unable to be notified of their status change via email/)
        end
      end
    end
  end

  describe 'POST create' do
    context 'with broken mailer' do
      context 'creating a pending passenger' do
        it 'saves the passenger and displays a warning message' do
          allow(PassengerMailer).to receive(:notify_pending).and_raise Net::SMTPFatalError

          new_passenger_params = {
            passenger: {
              active_status: 'pending',
              name: 'Pending Passenger',
              phone: '0000000000',
              address: '0 Nowhere Ln, Town, State',
              email: 'pendingpassenger@email.com',
              spire: '00000000@umass.edu',
              permanent: true
            }
          }
          post :create, params: new_passenger_params
          @passenger = Passenger.find_by(name: 'Pending Passenger')

          expect(@passenger).to be_present
          expect(response).to redirect_to(passenger_path(@passenger))
          expect(flash[:warning]).to match(/the passenger was unable to be notified via email/)
        end
      end
    end
  end

  describe 'POST update' do
    context 'with broken mailer' do
      context 'changing active to archived' do
        it 'saves the passenger and displays a warning message' do
          allow(PassengerMailer).to receive(:notify_archived).and_raise Net::SMTPFatalError

          @passenger = create :passenger, :permanent, active_status: 'active'
          post :update, params: { id: @passenger.id, passenger: { active_status: 'archived' } }
          @passenger.reload

          expect(@passenger.active_status).to eq 'archived'
          expect(response).to redirect_to(passenger_path(@passenger))
          expect(flash[:warning]).to match(/the passenger was unable to be notified of their status change via email/)
        end
      end
      context 'changing archived to active' do
        it 'saves the passenger and displays a warning message' do
          allow(PassengerMailer).to receive(:notify_active).and_raise Net::SMTPFatalError

          @passenger = create :passenger, :permanent, active_status: 'archived'
          post :update, params: { id: @passenger.id, passenger: { active_status: 'active' } }
          @passenger.reload

          expect(@passenger.active_status).to eq 'active'
          expect(response).to redirect_to(passenger_path(@passenger))
          expect(flash[:warning]).to match(/the passenger was unable to be notified of their status change via email/)
        end
      end
    end
  end

end
