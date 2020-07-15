class PassengerMailer < ApplicationMailer
  def notify_archived(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Special Transit Account Archived'
  end

  def send_brochure(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Your UMass Transit Account'
  end
  
end
