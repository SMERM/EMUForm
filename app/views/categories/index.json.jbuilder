json.array!(@categories) do |category|
  json.extract! category, :id, :acro, :title_en, :title_it, :description_en, :description_it
  json.url category_url(category, format: :json)
end
