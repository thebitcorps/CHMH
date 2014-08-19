json.array!(@seasons) do |season|
  json.extract! season, :id, :startdate, :enddate
  json.url season_url(season, format: :json)
end
