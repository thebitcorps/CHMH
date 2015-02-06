class SeasonsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_season, only: [:show, :edit, :update, :destroy]

  # GET /seasons
  # GET /seasons.json
  def index
    if user_signed_in?
      if current_user.role == "Admin"
        @seasons = Season.all.reverse
      else
        redirect_to root_path, :alert => "Acceso denegado."
      end
    else
      redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
  end

  # GET /seasons/1
  # GET /seasons/1.json
  def show
  end

  # GET /seasons/new
  def new
    if user_signed_in?
      if current_user.role == "Admin"
        @season = Season.new
      else
        redirect_to root_path, :alert => "Acceso denegado."
      end
    else
      redirect_to new_user_session_path, :alert => "Acceso denegado."
    end
  end

  # GET /seasons/1/edit
  def edit
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to root_path, notice: 'La temporada ha sido creada correctamente.' }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { render :new }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1
  # PATCH/PUT /seasons/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to root_path, notice: 'La temporada fue actualizada correctamente.' }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'La temporada fue eliminada correctamente.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      if user_signed_in?
        if current_user.role == "Admin"
          @season = Season.find(params[:id])
        else
          redirect_to root_path, :alert => "Acceso denegado."
        end
      else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.require(:season).permit(:startdate, :enddate)
    end
end
