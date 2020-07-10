# frozen_string_literal: true

require 'factory_bot'

class SessionsController < ApplicationController
  layout false
  skip_before_action :restrict_to_employee, :check_primary_account, :set_current_user

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
      @passengers = Passenger.temporary
    elsif request.post?
      if find_user
        redirect_to passengers_path and return
      end
      set_passenger
      redirect_to brochure_passengers_path
    end
  end

  private

  def find_user
    user = User.find_by(id: params[:user_id])
    session[:user_id] = user.id if user.present?
  end

  def set_passenger
    passenger = Passenger.find_by(id: params[:passenger_id])
    session[:passenger_id] = passenger.id if passenger.present?
    session[:spire] = new_spire
    session[:first_name] = FFaker::Name.first_name
    session[:last_name] = FFaker::Name.last_name
    session[:email] = FFaker::Internet.email
  end

  def new_spire
    if Passenger.any?
      (Passenger.pluck(:spire).map(&:to_i).max + 1).to_s.rjust(8, '0')
    else
      '0'*8
    end
  end
end
