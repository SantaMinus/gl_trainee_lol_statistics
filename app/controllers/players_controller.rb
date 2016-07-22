require 'lol'

class PlayersController < ApplicationController
  before_filter :authorize
  
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :client_connect, only: :create

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :region)
    end

    def client_connect
      @client = Lol::Client.new Player::API_KEY, {region: player_params[:region]}
    end

    def count_winrate
      summoner_id = @client.summoner.by_name(@player.name).first.id
      ranked_stats = @client.stats.ranked(summoner_id).champions

      #@player.winrate = 0
      #non_zero_modes = 0

      #ranked_stats.each do |mode|
      #  @player.winrate += mode.stats.total_sessions_won / mode.stats.total_sessions_played.to_f
      #  non_zero_modes += 1 if mode.stats.total_sessions_played != 0
      #end

      #@player.winrate /= non_zero_modes
      @player.winrate = ranked_stats.last.stats.total_sessions_won / ranked_stats.last.stats.total_sessions_played.to_f
    end
end
