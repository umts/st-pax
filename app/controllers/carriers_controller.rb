class CarriersController < ApplicationController

  def destroy
    if @carrier.destroy
      flash[:success] = 'Carrier was successfully destroyed.'
      redirect_to carriers_url
    else
      flash[:danger] = @carrier.errors.full_messages
      redirect_to carriers_url
    end
  end

  def index
    @carriers = Carrier.order :name
  end

  def update
  end

  def new
    @carrier = Carrier.new
  end

end
