class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :read, User
    case current_user.access_level
    when 'admin'
      @users = User.all
    when ['head_of_area', 'tutor']
      @users = User.where(area: current_user.area)
    end
  end

  def chart
    @user = User.find(params[:user_id])
    set_procedure_hash
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    authorize! :read, @user
    query = Procedure.by_user(@user) 
    @procedures = query.group(:surgery).count
    @procedure =  query.to_a
  end

  def new
    authorize! :create, User
    case current_user.access_level
    when 'admin'
      @user = User.new
    when 'head_of_area'
      @user = User.new(:area_id => current_user.area.id)
    end
  end

  def edit
    authorize! :update, User
    @user.season = Season.last
  end

  def create
    @user = User.new(user_params)
    if @user.access_level == "3"
      @user.season = Season.last
    end
    @user.password = "cambiarcontrasena"
    @user.name = @user.name.titleize
    @user.lastname = @user.lastname.titleize
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'El usuario fue creado satisfactoriamente' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.name = @user.name.titleize
        @user.lastname = @user.lastname.titleize
        @user = User.new(user_params)
        if @user.access_level == "3"
          @user.season = Season.last
        end
        @user.save
        format.html { redirect_to users_path, notice: 'Usuario modificado.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :action => "edit", :pd => params[:pd] }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Usuario borrado correctamente.' }
      format.json { head :no_content }
    end
  end
  # def update_season(user)
  #   user.season =  Season.last
  #    if user.save
  #       format.html { redirect_to user_path(user), notice: 'La temporada fue asignada correctamente' }
  #     else
  #        format.html { render :action => "edit", :pd => params[:pd] }
  #     end 
  # end
  private


    # should be called after the current_user is setting @user
    def set_procedure_hash
      if params[:type] == 'month'
        @procedures_hash = @user.month_procedure_count
      elsif params[:type] == 'day'
        @procedures_hash = @user.day_procedures_count
      else
        @procedures_hash = @user.month_procedure_count
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, :birthday, :gender, :role, :area_id, :pd, :season_id)
    end
end
