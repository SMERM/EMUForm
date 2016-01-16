json.array!(@works) do |work|
  json.extract! work, :id, :title, :year, :duration, :instruments, :program_notes_en, :program_notes_it
  json.url work_url(work, format: :json)
end
