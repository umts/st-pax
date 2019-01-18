class ChangeActiveAndPermanentToNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :passengers, :active, false, false
    change_column_null :passengers, :permanent, false, false
    change_column_default :passengers, :permanent, from: nil, to: false
  end
end
