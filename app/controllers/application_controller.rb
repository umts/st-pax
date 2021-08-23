# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :check_primary_account
  before_action :set_current_user
  before_action :login_as_passenger
  before_action :restrict_to_employee
  before_action :set_passenger_information

  private

  def deny_access
    if request.xhr?
      head :unauthorized
    else
      render 'sessions/unauthenticated', status: :unauthorized
    end
  end

  # Disable ABC size because this block will likely be
  # changed in a later branch
  # rubocop:disable Metrics/AbcSize
  def set_current_user
    @current_user =
      if session.key? :user_id
        User.active.find_by id: session[:user_id]
      elsif request.env.key? 'fcIdNumber'
        User.active.find_by spire: request.env['fcIdNumber']
      end
    session[:user_id] = @current_user.id if @current_user.present?
  end
  # rubocop:enable Metrics/AbcSize

  def login_as_passenger
    return if @current_user.present?

    @registrant =
      if session[:passenger_id]
        Passenger.find_by(id: session[:passenger_id])
      elsif request.env['fcIdNumber']
        find_or_initialize_passenger
      end
    session[:passenger_id] = @registrant&.id
  end

  def find_or_initialize_passenger
    passenger = Passenger.find_or_initialize_by(
      spire: request.env['fcIdNumber'],
      name: "#{request.env['givenName']} #{request.env['surName']}"
    )
    passenger.email = request.env['mail'] if passenger.new_record?
    passenger
  end

  def check_primary_account
    return if request.env['UMAPrimaryAccount'] == request.env['uid']

    @primary_account = request.env['UMAPrimaryAccount']
    @uid = request.env['uid']
    render 'sessions/subsidiary', status: :unauthorized
  end

  def restrict_to_admin
    deny_access && return unless @current_user&.admin?
  end

  def restrict_to_employee
    deny_access && return unless @current_user.present?
  end

  def set_passenger_information
    @pending = Passenger.pending.count
  end
end
