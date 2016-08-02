# a player controller
require 'lol'

class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_service, except: [:index, :new, :destroy]

  def index
    @players = Player.all
  end

  def show
    @player_service.get_statistics(@player, true) if @player.kda == nil
  end

  def new
    @player = Player.new
  end

  def edit
  end

  def create
    unless Player.exists?(name: player_params[:name], region: player_params[:region])
      @player = Player.new(player_params) 
      @player_service.get_statistics(@player, true)
    else
      @player = Player.find_by(name: player_params[:name], region: player_params[:region])
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
  end

  def update
    @player_service.get_statistics(@player, true)
    render :show
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
