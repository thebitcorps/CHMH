json.array!(@procedures) do |procedure|
  json.extract! procedure, :id, :donedate, :starttime, :endtime, :notes, :user_id, :surgery_id, :task
  json.url procedure_url(procedure, format: :json)
end
