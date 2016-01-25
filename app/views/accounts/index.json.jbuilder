json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :about
  json.url account_url(account, format: :json)
end
