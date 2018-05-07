require 'prawn/table'

class PassengersPDF < Prawn::Document
  # what is the name of this file?
  def initialize(passengers, filters)
    super(page_layout: :landscape, page_size: "TABLOID")
    header(filters)
    passengers_table(passengers)
  end

  def passengers_table(passengers)
    font_size 14
    passenger_table = [["Name", "Mobility Device", "Phone", "Expiration Date", "Notes"]]

    passengers.each do |passenger|
      name = passenger.name
      mobility_device = passenger.mobility_device.try(:name)
      phone = passenger.phone
      expiration = passenger.expiration_display
      note = passenger.note
      passenger_table << [ name, mobility_device, phone, expiration, note ]
    end
    table(passenger_table) do
      row(0).font_style = :bold
    end
  end

  def header(filters)
    font_size 30
    date = Time.now.strftime("%m/%d/%Y")
    text (filters + ['Passengers', date]).map(&:capitalize).join(' '), style: :bold, size: 30
    move_down 20
  end
end