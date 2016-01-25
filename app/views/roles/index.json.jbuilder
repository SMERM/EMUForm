json.array!(@roles) do |role|
  json.extract! role, :id, :description
  json.url role_url(role, format: :json)
end
