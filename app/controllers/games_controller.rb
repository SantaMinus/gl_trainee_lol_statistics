require 'lol'
require 'date'

class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def create
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
  end

  def show
    @player = Player.find(params[:id])
    @game_request = Lol::CurrentGameRequest.new(Player::API_KEY, @player.region)
    begin
      @game_info = @game_request.spectator_game_info(get_platform(@player.region), @player.summoner_id)
      @start_time = Time.at(@game_info.game_start_time).to_datetime

      if Game.exists?(start_time: @start_time)
        @game = Game.find_by(start_time: @start_time)
      else
        create
      end
      predict_victory
    rescue
      render :not_found
    end
  end

  private
    def get_platform(region)
      platform = region.upcase
      platform << '1' unless region.in? ['kr', 'ru']
      platform
    end

    def predict_victory
      @player_service = LolPlayerService.new(@player)
      @team1_winrate = @team2_winrate = 0.0
      @game_info.participants.each_with_index do |participant, index|
        player = Player.find_by(name: participant.summoner_name)
        @player_service.get_statistics(player) if player.winrate == nil
        player_winrate = player.winrate

        case index
        when 0..4
          @team1_winrate += player_winrate
        when 5..9
          @team2_winrate += player_winrate
        end
      end
      @team1_winrate /= 5.0
      @team2_winrate /= 5.0
      @game.result = (@team1_winrate + @team2_winrate) / 2
      @game.winner = @team1_winrate > @team2_winrate ? 1 : 2
      @game.save
    end
end
