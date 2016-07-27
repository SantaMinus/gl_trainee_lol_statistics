require 'lol'

class GameController < ApplicationController
  def create(player)
    @game = Game.new
    @player = player
    @player_service = LolPlayerService.new(@player)
    @player_service.client_connect(@player.region)

    @game_request = Lol::CurrentGameRequest.new(Player::API_KEY, @player.region)
    game_info = @game_request.spectator_game_info(platform, @player.summoner_id)
    if game_info
      @game.mode = @game_info.game_mode
      @game.start_time = @game_info.game_start_time
      @game.is_finished = false
    end
  end

  def show
    binding.pry
    create(params)
  end
end
