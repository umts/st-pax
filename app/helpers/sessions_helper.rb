# frozen_string_literal: true

# :nocov:
module SessionsHelper
  def dev_login_options(users)
    users.group_by { |user| user.admin? ? 'Admins' : 'Dispatchers' }.transform_values do |user_group|
      user_group.map { |user| [user.name, user.id] }
    end
  end
end
# :nocov:
