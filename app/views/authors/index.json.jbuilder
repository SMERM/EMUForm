json.array!(@authors) do |author|
  json.extract! author, :id, :first_name, :last_name, :birth_year, :bio_en, :bio_it
  json.url author_url(author, format: :json)
end
