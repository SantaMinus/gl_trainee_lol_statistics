# a player controller
require 'lol'

class PlayersController < ApplicationController
  before_filter :authorize
  
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_service

  def index
    @players = Player.all
  end

  def show
    @service.get_statistics(@player)
  end

  def new
    @player = Player.new
  end

  def edit
  end

  def create
    @player = Player.new(player_params)
    @service.get_statistics(@player)

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
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
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
      @service = LolPlayerService.new(@player)
    end
end
