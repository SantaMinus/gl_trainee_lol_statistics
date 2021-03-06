# a player controller
require 'lol'

class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update_player, :destroy]
  before_action :set_service, except: [:index, :new, :destroy]

  def index
    @players = Player.paginate(page: params[:page], per_page: 20)
  end

  def show
    @player_service.get_statistics(@player) if @player.skill_points.nil?
  rescue Lol::TooManyRequests
    flash.now[:notice] = "Unfortunately, the application has met a RIOT server rate limit. Please refresh this page once more."
    binding.pry
  end

  def new
    @player = Player.new
  end

  def create
    if Player.exists?(name: player_params[:name], region: player_params[:region])
      @player = Player.find_by(name: player_params[:name], region: player_params[:region])
    else
      @player = Player.new(player_params)
      @player_service.get_statistics(@player)
    end

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  rescue
    render :summoner_not_found
  end

  # GET /players/:id/update
  def update_player
    @player_service.get_statistics(@player)
    render :show
  rescue
    flash.now[:notice] = "The summoner with such name doesn't exist. Please double check the summoner's name or a region."
    binding.pry
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def set_player
      @player = Player.find(params[:id])
    end

    def player_params
      params.require(:player).permit(:name, :region)
    end

    def set_service
      @player_service = LolPlayerService.new(@player)
    end
end
