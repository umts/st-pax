# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy toggle_archive]
  before_action :access_control, only: %i[destroy archived toggle_archive]

  def archived
    @passengers = Passenger.archived
  end

  def register
    @doctors_note = @registrant.doctors_note || DoctorsNote.new
    return if request.get?
    @registrant = Passenger.new registration_params
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

  def toggle_archive
    if @passenger.archived?
      @passenger.active!
    else
      # skip validations on archival
      @passenger.update_attribute(:active_status, 'archived')
    end
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

  def passenger_params
    base_passenger_params
      .then { |p| restrict_admin p }
      .then { |p| disallow_nonexpiring_note p }
  end

  def base_passenger_params
    passenger_params = params.require(:passenger)
      .permit(:name, :address, :email, :phone, :mobility_device_id,
              :permanent, :note, :spire, :status, :has_brochure,
              :registered_with_disability_services,
              doctors_note_attributes: %i[expiration_date])
    passenger_params[:active_status] = params[:passenger][:active]
    passenger_params
  end

  def disallow_nonexpiring_note(permitted_params)
    note_params = permitted_params[:doctors_note_attributes]
    return permitted_params unless note_params.try(:[], :expiration_date).blank?

    permitted_params.except :doctors_note_attributes
  end

  def restrict_admin(permitted_params)
    return permitted_params if @current_user.admin?

    permitted_params.except :permanent
  end

  def registration_params
    params.require(:passenger).permit(
      :preferred_name,
      :email,
      :phone,
      :address,
      :mobility_device_id,
      :needs_assistance,
      doctors_note_attributes: %i[expiration_date doctors_name doctors_address doctors_phone]
    ).merge!(
      spire: "#{request.env['fcIdNumber']}@umass.edu",
      name: "#{request.env['givenName']} #{request.env['surName']}",
    )
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end
end
