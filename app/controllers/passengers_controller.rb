# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy toggle_status]
  before_action :restrict_to_admin, only: %i[destroy archived toggle_status]
  before_action :restrict_to_employee, except: %i[register brochure create]
  before_action :access_control, only: %i[destroy]

  def archived
    @passengers =
      Passenger.archived.includes(:eligibility_verification, :mobility_device)
  end

  def pending
    @passengers = Passenger.pending
  end

  def register
    if request.get?
      @doctors_note = @registrant.doctors_note || DoctorsNote.new
      return
    end
    @registrant = Passenger.new passenger_params
    if @registrant.save
      flash[:success] = 'Registration request successfully submitted. '\
        'Please read the policies and ride scheduling information below.'
      redirect_to brochure_passengers_url
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
    @passenger = Passenger.new(active_status: 'active')
    @verification = EligibilityVerification.new
  end

  def edit
    @verification = @passenger.eligibility_verification || EligibilityVerification.new
  end

  def index
    @passengers = Passenger.where(active_status: ['active', 'pending'])
      .includes(:eligibility_verification, :mobility_device).order :name
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
      :terms_and_conditions,
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
