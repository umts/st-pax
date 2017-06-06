json.extract! passenger, :name, :address, :email, :phone, :wheelchair, :active, :permanent, :created_at, :updated_at
json.url passenger_url(passenger, format: :json)
