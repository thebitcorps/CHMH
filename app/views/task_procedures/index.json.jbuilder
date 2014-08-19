json.array!(@task_procedures) do |task_procedure|
  json.extract! task_procedure, :id, :procedure_id, :task_belongs_to
  json.url task_procedure_url(task_procedure, format: :json)
end
