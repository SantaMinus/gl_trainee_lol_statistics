require 'lol'
require 'date'

class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  # shows a game if it's in a DB, if not - creates. If the player is not in game, renders a message.
  def show
    @player = Player.find(params[:id])
    @game_request = Lol::CurrentGameRequest.new(Player::API_KEY, @player.region)
    @game_info = @game_request.spectator_game_info(get_platform(@player.region), @player.summoner_id)

    @start_time = Time.at(@game_info.game_start_time.to_s[0..9].to_i)

    if Game.exists?(start_time: @start_time)
      @game = Game.find_by(start_time: @start_time)
    else
      create_game
    end
    predict_victory

    rescue Lol::TooManyRequests
      flash.now[:error] = "Unfortunately, the application has met a RIOT server rate limit. Please refresh this page once more."
    rescue Lol::NotFound
      render :game_not_found
  end

  private

    # converts a region into a platform to find the game on RIOT server
    def get_platform(region)
      platform = region.upcase
      platform << '1' unless region.in? ['kr', 'ru']
      platform
    end

    # creates a record in the DB if the game exists
    def create_game
      @game = Game.new

      @game.mode = @game_info.game_mode
      @game.start_time = @start_time
      @game.save
      
      @game_info.participants.each do |participant|
        player = if Player.exists?(name: participant.summoner_name, region: @player.region)
                   Player.find_by(name: participant.summoner_name, region: @player.region) 
                 else
                   Player.create(name: participant.summoner_name, region: @player.region)
                 end
        Participant.create(game_id: @game.id, player_id: player.id) unless Participant.exists?(game_id: @game.id, player_id: player.id)
      end
      predict_victory

    rescue Lol::TooManyRequests
      redirect_to :back, :flash => { :error => "Unfortunately, the application has met a service rate limit. Please refresh this page once more." }
    rescue Lol::NotFound
      binding.pry
      return
    end

    # makes victory prediction based on winrate&KDA. Skill points are to be added.
    def predict_victory
      @player_service = LolPlayerService.new(@player)
      @team1_winrate = @team2_winrate = @team1_kda = @team2_kda = @team1_skill_points = @team2_skill_points = 0.0

      @game_info.participants.each_with_index do |participant, index|
        player = Player.find_by(name: participant.summoner_name)
        player = Player.create(name: participant.summoner_name, region: @player.region) unless player

        @player_service.get_statistics(player) if player.skill_points.nil?

        case index
        when 0..4
          @team1_winrate += player.winrate || 0
          @team1_kda += player.kda || 0
          @team1_skill_points += player.skill_points
        when 5..9
          @team2_winrate += player.winrate || 0
          @team2_kda += player.kda || 0
          @team2_skill_points += player.skill_points
        end
      end
      @team1_winrate, @team2_winrate, @team1_kda, @team2_kda, @team1_skill_points, @team2_skill_points =
        [@team1_winrate, @team2_winrate, @team1_kda, @team2_kda, @team1_skill_points, @team2_skill_points].map! { |x| x / 5.0 }
      team1_total = @team1_winrate * 20 + @team1_kda + @team1_skill_points * 0.01
      team2_total = @team2_winrate * 20 + @team2_kda + @team2_skill_points * 0.01

      @game.result ||= [team1_total, team2_total].max / (team1_total + team2_total) * 100
      @game.winner ||= team1_total > team2_total ? 1 : 2
      @game.save
    end
end
