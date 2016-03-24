json.array!(@editions) do |edition|
  json.extract! edition, :id, :year, :title, :start_date, :end_date, :description_en, :description_it, :submission_deadline
  json.url edition_url(edition, format: :json)
end
