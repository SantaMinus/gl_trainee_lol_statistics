require 'lol'

class LolPlayerService
  def initialize(player)
    @player = player
  end

  def client_connect(*region)
    region = region.first if region
    region ||= player_params[:region]
    @client = Lol::Client.new(Player::API_KEY, region: region)
  end

  def set_summoner_id
    @player.summoner_id = @client.summoner.by_name(@player.name).first.id
  end

  def count_winrate
    set_summoner_id
    ranked_stats = @client.stats.ranked(@player.summoner_id).champions.last.stats
    @player.winrate = ranked_stats.total_sessions_won / ranked_stats.total_sessions_played.to_f
  end

  def count_kda
    games = @client.game.recent(@player.summoner_id)
    @player.kda = 0
    k = d = a = 0

    games.each do |g|
      k += g.stats.champions_killed || 0
      d += g.stats.num_deaths || 0
      a += g.stats.assists || 0
    end

    len = games.count
    @player.kills = avg(k.to_f, len)
    @player.deaths = avg(d.to_f, len)
    @player.assists = avg(a.to_f, len)
    @player.kda += (@player.kills + @player.assists) / @player.deaths
    @player.save
  end

  def avg(value, count)
    value / count
  end

  def get_statistics(player, new_player=true)
    @player = player
    client_connect(@player.region) if new_player
    set_summoner_id
    count_winrate
    count_kda
  end
end
