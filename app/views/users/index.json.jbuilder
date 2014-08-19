json.array!(@users) do |user|
  json.extract! user, :id, :name, :lastname, :email, :password, :birthday, :role
  json.url user_url(user, format: :json)
end
