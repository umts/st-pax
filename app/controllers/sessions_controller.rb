# frozen_string_literal: true

require 'factory_bot'

class SessionsController < ApplicationController
  layout false
  skip_before_action :access_control, :check_primary_account, :set_current_user

  def destroy
    session.clear
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.umass.edu/Logout'
    else redirect_to dev_login_path
    end
  end

  # route not defined in production
  def dev_login
    if request.get?
      @admins = User.admins.order :name
      @dispatchers = User.dispatchers.order :name
      @passengers = Passenger.temporary.limit(5)
    elsif request.post?
      if find_user
        redirect_to passengers_path and return
      end
      set_passenger
      redirect_to register_passengers_path and return
    end
  end

  private

  def find_user
    user = User.find_by(id: params[:user_id])
    session[:user_id] = user.id if user.present?
  end

  def set_passenger
    passenger = Passenger.find_by(id: params[:passenger_id])
    passenger ||= FactoryBot.create :passenger, :temporary
    session[:passenger_id] = passenger.id
  end
end
