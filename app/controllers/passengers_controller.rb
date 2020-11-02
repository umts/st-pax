# frozen_string_literal: true

class PassengersController < ApplicationController
  before_action :find_passenger,
                only: %i[show edit update destroy set_status]
  before_action :restrict_to_admin, only: %i[destroy]
  skip_before_action :restrict_to_employee,
    only: %i[brochure new edit create show new_or_edit_registration]

  SMTP_ERROR_APPENDIX =
    'but the email followup was unsuccessful.' +
    ' Please check the validity of the email address.'

  def archived
    @passengers =
      Passenger.archived.includes(:eligibility_verification, :mobility_device)
  end

  def pending
    @passengers =
      Passenger.pending.includes(:eligibility_verification, :mobility_device)
  end

  def brochure; end

  def set_status
    begin
      if @passenger.set_status(params[:status])
        flash[:success] = 'Passenger successfully updated'
        redirect_to passengers_url
      else
        flash[:danger] = @passenger.errors.full_messages
        redirect_to edit_passenger_path(@passenger)
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Passenger successfully updated, #{SMTP_ERROR_APPENDIX}"
      redirect_to passengers_url
    end
  end

  def check_existing
    @passenger = Passenger.find_by(spire: params[:spire_id])
    return unless @passenger.present?

    render partial: 'check_existing'
  end

  def new
    @passenger = if @current_user.present?
                   Passenger.new(active_status: 'active')
                 elsif @registrant.present?
                   @registrant
                 end
    @verification = EligibilityVerification.new
  end

  def edit
    @verification = @passenger.eligibility_verification || EligibilityVerification.new
  end

  def new_or_edit_registration
    @passenger = @registrant
    if @passenger&.persisted?
      redirect_to action: :edit, id: @passenger.id
    else
      redirect_to action: :new
    end
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
    @passenger.registerer = @current_user
    begin
      if @passenger.save
        flash[:success] = 'Passenger registration successful'
        redirect_to @passenger
      else
        flash.now[:danger] = @passenger.errors.full_messages
        render :new
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Passenger registration successful, #{SMTP_ERROR_APPENDIX}"
      redirect_to @passenger
    end
  end

  def update
    @passenger.assign_attributes passenger_params
    begin
      if @passenger.save
        flash[:success] = 'Registration successfully updated.'
        redirect_to @passenger
      else
        flash[:danger] = @passenger.errors.full_messages
        render :edit
      end
    rescue Net::SMTPFatalError
      flash[:warning] = "Registration successfully updated, #{SMTP_ERROR_APPENDIX}"
      redirect_to @passenger
    end
  end

  def destroy
    @passenger.destroy
    flash[:success] = 'Passenger successfully destroyed.'
    redirect_to passengers_url
  end

  private

  def all_params
    passenger_params =
      params.require(:passenger)
            .permit(:name, :address, :email, :phone, :active_status,
                    :mobility_device_id, :permanent, :note, :spire,
                    :has_brochure,
                    eligibility_verification_attributes: %i[
                      expiration_date verifying_agency_id name address phone
                    ])
    passenger_params
  end

  def find_passenger
    @passenger = Passenger.find(params[:id])
  end

  def passenger_pdf
    @passengers = @passengers.send(@filter)
    pdf = PassengersPDF.new(@passengers, @filter)
    name = "#{@filter} Passengers #{Date.today}".capitalize
    send_data pdf.render, filename: name,
                          type: 'application/pdf',
                          disposition: :inline
  end

  def passenger_params
    return all_params if @current_user&.admin?
    return all_params.except(:permanent) if @current_user.present?
    all_params
      .except(:spire, :name, :permanent)
      .merge!(spire: "#{request.env['fcIdNumber']}@umass.edu",
              name: "#{request.env['givenName']} #{request.env['surName']}")
  end
end
