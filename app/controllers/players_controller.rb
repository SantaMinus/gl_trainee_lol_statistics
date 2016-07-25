# a player controller
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
    client_connect(@player.region)
    set_summoner_id unless @player.summoner_id
    count_winrate
    count_KDA
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
    client_connect
    set_summoner_id
    count_winrate

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

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
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

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was destroyed.' }
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

    def client_connect(*region)
      region = region.first if region
      region ||= player_params[:region]
      @client = Lol::Client.new Player::API_KEY, { region: region }
    end

    def count_winrate
      summoner_id = @client.summoner.by_name(@player.name).first.id
      ranked_stats = @client.stats.ranked(summoner_id).champions

      @player.winrate = ranked_stats.last.stats.total_sessions_won / ranked_stats.last.stats.total_sessions_played.to_f
    end

    def count_KDA
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
    end

    def avg(value, count)
      value / count
    end

    def set_summoner_id
      @player.summoner_id = @client.summoner.by_name(@player.name).first.id
    end
end
