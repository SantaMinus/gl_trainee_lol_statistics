require 'lol'
require 'date'

class GamesController < ApplicationController
  def create(player_id)
    @game = Game.new
    @player = Player.find(player_id)

    @player_service = LolPlayerService.new(@player)
    @game_request = Lol::CurrentGameRequest.new(Player::API_KEY, @player.region)
    game_info = @game_request.spectator_game_info(get_platform(@player.region), @player.summoner_id)
    if game_info
      @game.mode = game_info.game_mode
      @game.start_time = Time.at(game_info.game_start_time).to_datetime
      @game.save
      game_info.participants.each do |participant|
      	player = Player.create(name: participant.summoner_name, region: @player.region)
      	Participant.create(game_id: @game.id, player_id: player.id)
      end
    end
  end

  def show
    create(params[:id])
  end

  def get_platform(region)
  	platform = region.upcase
  	platform << '1' unless region.in? ['kr', 'ru']
  	platform
  end
end
