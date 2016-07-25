class BannedChampionsController < ApplicationController
  before_action :set_banned_champion, only: [:show, :edit, :update, :destroy]

  # GET /banned_champions
  # GET /banned_champions.json
  def index
    @banned_champions = BannedChampion.all
  end

  # GET /banned_champions/1
  # GET /banned_champions/1.json
  def show
  end

  # GET /banned_champions/new
  def new
    @banned_champion = BannedChampion.new
  end

  # GET /banned_champions/1/edit
  def edit
  end

  # POST /banned_champions
  # POST /banned_champions.json
  def create
    @banned_champion = BannedChampion.new(banned_champion_params)

    respond_to do |format|
      if @banned_champion.save
        format.html { redirect_to @banned_champion, notice: 'Banned champion was successfully created.' }
        format.json { render :show, status: :created, location: @banned_champion }
      else
        format.html { render :new }
        format.json { render json: @banned_champion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banned_champions/1
  # PATCH/PUT /banned_champions/1.json
  def update
    respond_to do |format|
      if @banned_champion.update(banned_champion_params)
        format.html { redirect_to @banned_champion, notice: 'Banned champion was successfully updated.' }
        format.json { render :show, status: :ok, location: @banned_champion }
      else
        format.html { render :edit }
        format.json { render json: @banned_champion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banned_champions/1
  # DELETE /banned_champions/1.json
  def destroy
    @banned_champion.destroy
    respond_to do |format|
      format.html { redirect_to banned_champions_url, notice: 'Banned champion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banned_champion
      @banned_champion = BannedChampion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def banned_champion_params
      params.require(:banned_champion).permit(:champion_id, :team_id, :pick_turn)
    end
end
