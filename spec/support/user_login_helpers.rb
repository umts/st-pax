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
  page.set_rack_session(user_id: user.id)
end
