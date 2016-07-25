json.array!(@banned_champions) do |banned_champion|
  json.extract! banned_champion, :id, :champion_id, :team_id, :pick_turn
  json.url banned_champion_url(banned_champion, format: :json)
end
