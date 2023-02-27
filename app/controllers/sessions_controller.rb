# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :restrict_to_employee, :check_primary_account, :set_current_user,
                     :login_as_passenger, :require_authentication

  def destroy
    session.clear
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.umass.edu/Logout'
    else redirect_to dev_login_path
    end
  end

  # route not defined in production
  # :nocov:
  def dev_login
    if request.get?
      @users = User.order :name
      @passengers = Passenger.temporary.order :name
    elsif request.post?
      redirect_to passengers_path and return if find_user

      set_passenger
      redirect_to brochure_passengers_path
    end
  end

  private

  def fake_passenger_attributes
    {
      spire: new_spire,
      first_name: FFaker::Name.first_name,
      last_name: FFaker::Name.last_name,
      email: FFaker::Internet.email
    }
  end

  def find_user
    user = User.find_by(id: params[:user_id])
    session[:user_id] = user.id if user.present?
  end

  def new_spire
    num = Passenger.maximum(:spire).to_i + 1
    format('%08i@umass.edu', num)
  end

  def set_passenger
    passenger = Passenger.find_by(id: params[:passenger_id])
    session[:passenger_id] = passenger.id if passenger.present?
    session.merge! fake_passenger_attributes
  end
  # :nocov:
end
