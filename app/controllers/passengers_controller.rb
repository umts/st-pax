class PassengersController < ApplicationController
  def new
    @passenger = Passenger.new
  end

  def index
    @permanent = params[:filter] == 'permanent'
    @temporary = params[:filter] == 'temporary'
    @all = params[:filter] == 'all'
    @search_term = params[:search]
    @passengers = Passenger.order :name
    @passengers = @passengers.search(@search_term) if @search_term.present?
    @passengers = @passengers.permanent if @permanent.present?
    @passengers = @passengers.temporary if @temporary.present?
  end

  def show
    @passenger = Passenger.find(params[:id])
  end

  def edit
    @passenger = Passenger.find(params[:id])
  end

  def create
    @passenger = Passenger.new(passenger_params)

    respond_to do |format|
      if @passenger.save
        format.html { redirect_to @passenger, notice: 'Passenger was successfully created.' }
        format.json { render :show, status: :created, location: @passenger }
      else
        format.html { render :new }
        format.json { render json: @passenger.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @passenger = Passenger.find(params[:id])
      if @passenger.update(passenger_params)
        format.html { redirect_to @passenger, notice: 'Passenger was successfully updated.' }
        format.json { render :show, status: :ok, location: @passenger }
      else
        format.html { render :edit }
        format.json { render json: @passenger.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @passenger = Passenger.find(params[:id])
    @passenger.destroy
    respond_to do |format|
      format.html { redirect_to passengers_url, notice: 'Passenger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def passenger_params
    permitted_attrs = params.require(:passenger).permit(:name, :address, :email, :phone,
      :wheelchair, :active, :permanent, :expiration, :note)
    expiration_date = permitted_attrs[:expiration]
    permitted_attrs[:expiration] = Date.strptime(expiration_date, '%m/%d/%Y')
    permitted_attrs
  end
end
