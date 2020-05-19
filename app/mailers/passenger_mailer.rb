class PassengerMailer < ApplicationMailer
  def notify_archived(passenger)
    @passenger = passenger
    mail to: @passenger.email, subject: 'Special Transit Account Archived'
  end
end
