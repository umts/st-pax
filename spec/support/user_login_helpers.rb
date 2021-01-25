# frozen_string_literal: true

def when_current_user_is(user)
  current_user =
    case user
    when Symbol then create :user, user
    when User then user
    when nil then nil
    else raise ArgumentError, 'Invalid user type'
    end
  login_as current_user
end

def login_as(user)
  case user
  when User
    page.set_rack_session(user_id: user.id)
  when Passenger
    if user.persisted?
      page.set_rack_session(passenger_id: user.id)
    else
      name = user.name.split
      page.set_rack_session(spire: user.spire.split('@').first,
                            first_name: name.first,
                            last_name: name.last,
                            email: user.email)
    end
  end
end
