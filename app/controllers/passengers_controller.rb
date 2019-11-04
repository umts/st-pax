# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy toggle_status]
  before_action :restrict_to_admin, only: %i[destroy archived toggle_status]
  before_action :restrict_to_employee, except: %i[register brochure create]
  # add edit/update to allowed actions for passenger after question is answered

  def archived
    @passengers = Passenger.archived
  end

  def pending
    @passengers = Passenger.pending
  end

  def register
    @doctors_note = @registrant.doctors_note || DoctorsNote.new
    return if request.get?
    @registrant = Passenger.new passenger_params
    unless params[:terms_and_conditions]
      flash.now[:danger] = 'Please accept the terms and conditions'
      render :register and return
    end
    if @registrant.save
      flash[:success] = 'Registration request successfully submitted. '\
        'Please read the policies and ride scheduling information below.'
      redirect_to passengers_brochure_path
    else
      flash.now[:danger] = @registrant.errors.full_messages
      render :register
    end
  end

  def brochure
  end

  def toggle_status
    desired_status = params[:status]
    @passenger.toggle_status(desired_status)
    flash[:success] = 'Passenger successfully updated'
    redirect_to passengers_url
  end

  def check_existing
    @passenger = Passenger.find_by(spire: params[:spire_id])
    return unless @passenger.present?
    render partial: 'check_existing'
  end

  def new
    @passenger = Passenger.new
    @doctors_note = DoctorsNote.new
  end

  def edit
    @doctors_note = @passenger.doctors_note || DoctorsNote.new
  end

  # rubocop:disable Style/GuardClause
  def index
    @passengers = Passenger.active.order :name
    @filters = []
    filter = params[:filter]
    if %w[permanent temporary].include? filter
      @passengers = @passengers.send filter.downcase
      @filters << filter
    else @filters << 'all'
    end
    if params[:print].present?
      pdf = PassengersPDF.new(@passengers, @filters)
      name = "#{@filters.map(&:capitalize).join(' ')} Passengers #{Date.today}"
      send_data pdf.render, filename: name,
                            type: 'application/pdf',
                            disposition: :inline
    end
  end
  # rubocop:enable Style/GuardClause

  def create
    @passenger = Passenger.new(passenger_params)
    @passenger.registered_by = @current_user
    if @passenger.save
      flash[:success] = 'Passenger successfully created.'
      redirect_to @passenger
    else
      flash.now[:danger] = @passenger.errors.full_messages
      render :new
    end
  end

  def update
    @passenger.assign_attributes passenger_params
    if @passenger.save
      flash[:success] = 'Passenger successfully updated.'
      redirect_to @passenger
    else
      flash[:danger] = @passenger.errors.full_messages
      render :edit
    end
  end

  def destroy
    @passenger.destroy
    flash[:success] = 'Passenger successfully destroyed.'
    redirect_to passengers_url
  end

  private

  def all_params
    base_params = params.require(:passenger).permit(
      :name,
      :preferred_name,
      :email,
      :phone,
      :address,
      :mobility_device_id,
      :needs_assistance,
      :note,
      :status,
      :registered_with_disability_services,
      :permanent,
      :spire,
      doctors_note_attributes: %i[expiration_date doctors_name doctors_address doctors_phone]
    )
    base_params[:active_status] = params[:passenger][:active]
    base_params
  end

  def passenger_params
    return all_params if @current_user&.admin?
    return all_params.except(:permanent) if @current_user.present?
    all_params.except(
      :spire,
      :name,
      :permanent
    ).merge!(
      spire: "#{request.env['fcIdNumber']}@umass.edu",
      name: "#{request.env['givenName']} #{request.env['surName']}",
    )
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end
end
