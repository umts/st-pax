# frozen_string_literal: true

module PassengersHelper
  def passengers_table_class
    if @current_user.admin?
      'row-border admin-table'
    else
      'row-border dispatch-table'
    end
  end
end
