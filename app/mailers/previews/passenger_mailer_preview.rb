# frozen_string_literal: true

class PassengerMailerPreview < ActionMailer::Preview
  def notify_archived
    PassengerMailer.notify_archived passenger
  end

  def notify_active
    PassengerMailer.notify_active passenger
  end

  def notify_pending
    PassengerMailer.notify_pending passenger
  end

  private

  def passenger
    Passenger.first
  end
end
