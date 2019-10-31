# frozen_string_literal: true

module PassengersHelper
  def doctors_note_fields_class
    'hide-view' if @passenger.permanent?
  end

  def passengers_table_row_class(passenger)
    if passenger.doctors_note&.will_expire_within_warning_period?
      'expires-soon'
    elsif passenger.needs_doctors_note?
      'needs-note'
    elsif passenger.rides_expired?
      'expired'
    end
  end

  def sortable_date(note)
    note.expiration_date.strftime('%Y%m%d') if note.present?
  end

  def needs_assistance_label
    subject = if @current_user
                'The passenger'
              else
                'I'
              end
    "#{subject} will need assistance getting to and from buildings"
  end

  def expiration_date_label
    subject = if @current_user
                'the passenger'
              else
                'you'
              end
    "How long will #{subject} be with us?"
  end
end
