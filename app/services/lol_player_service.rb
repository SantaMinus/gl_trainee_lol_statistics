require 'lol'

class LolPlayerService
  def initialize(player)
    @player = player
  end

  # establishes connection to RIOT server
  def client_connect(*region)
    region = region.first if region
    region ||= player_params[:region]
    @client = Lol::Client.new(Player::API_KEY, region: region)
  end

  # gets Summoner ID from RIOT server and sets it to a player
  def set_summoner_id
    @player.summoner_id ||= @client.summoner.by_name(@player.name).first.id
  rescue Lol::NotFound
    # flash.now[:error] = "The summoner with such name doesn't exist. Please double check the summoner's name or a region."
  end

  # counts player's winrate
  def count_winrate
    set_summoner_id
    ranked_stats = @client.stats.ranked(@player.summoner_id).champions.last.stats
    @player.winrate = ranked_stats.total_sessions_won / ranked_stats.total_sessions_played.to_f
  end

  # counts KDA = Kills/Deaths/Assists statistics
  def count_kda
    games = @client.game.recent(@player.summoner_id)
    @player.kda = k = d = a = 0

    games.each do |g|
      k += g.stats.champions_killed || 0
      d += g.stats.num_deaths || 0
      a += g.stats.assists || 0
    end

    len = games.count
    @player.kills, @player.deaths, @player.assists = [k, d, a].map! { |x| x / len }
    @player.kda += (@player.kills + @player.assists) / @player.deaths
  end

  # main method to get 2winrate, KDA and estimated skill points
  def get_statistics(player)
    @player = player
    client_connect(@player.region)
    set_summoner_id
    count_winrate
    count_kda
    count_skill_points
    @player.save
  end

  # counts skill points - estimated points based on division and tier of a player
  def count_skill_points
    entries = @client.league.get(@player.summoner_id).entries[0][1][0]
    league_entry = entries.entries.find { |entry| entry.player_or_team_name == @player.name }

    division = league_entry.division
    lp = league_entry.league_points
    tier = entries.tier
    @player.skill_points = 0

    case tier
    when 'SILVER'
      @player.skill_points += 500
    when 'GOLD'
      @player.skill_points += 1000
    when 'PLATINUM'
      @player.skill_points += 1500
    when 'DIAMOND'
      @player.skill_points += 2000
    when 'MASTER'
      @player.skill_points += 2500
    when 'CHALLENGER'
      @player.skill_points += 3000
    end

    case division
    when 'IV'
      @player.skill_points += 100
    when 'III'
      @player.skill_points += 200
    when 'II'
      @player.skill_points += 300
    when 'I'
      @player.skill_points += 400
    end

    @player.skill_points += lp

  rescue Lol::NotFound
    @player.skill_points = 0
    # specify more accurate value
  end
end
