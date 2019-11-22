# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy toggle_archive]
  before_action :access_control, only: %i[destroy archived toggle_archive]

  def archived
    @passengers = Passenger.archived
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
    @verification = EligibilityVerification.new
  end

  def edit
    @verification = @passenger.eligibility_verification || EligibilityVerification.new
  end

  def index
    @passengers = Passenger.active.order :name
    allowed_filters = %w[permanent temporary]
    @filter = allowed_filters.find { |f| f == params[:filter] } || 'all'

    respond_to do |format|
      format.html
      format.pdf { passenger_pdf }
    end
  end

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

  def base_passenger_params
    passenger_params =
      params.require(:passenger)
            .permit(:name, :address, :email, :phone, :active_status,
                    :mobility_device_id, :permanent, :note, :spire, :status,
                    :has_brochure, :registered_with_disability_services,
                    eligibility_verification_attributes: %i[expiration_date verifying_agency_id])
    passenger_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end

  def passenger_params
    base_passenger_params.then { |p| restrict_admin p }
  end

  def passenger_pdf
    @passengers = @passengers.send(@filter)
    pdf = PassengersPDF.new(@passengers, @filter)
    name = "#{@filter} Passengers #{Date.today}".capitalize
    send_data pdf.render, filename: name,
                          type: 'application/pdf',
                          disposition: :inline
  end

  def restrict_admin(permitted_params)
    return permitted_params if @current_user.admin?

    permitted_params.except :permanent
  end
end
