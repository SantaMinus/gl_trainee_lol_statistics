json.array!(@games) do |game|
  json.extract! game, :id, :mode, :start
  json.url game_url(game, format: :json)
end
