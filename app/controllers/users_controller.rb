class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if user_signed_in?
      if current_user.role == "Admin"
        @users = User.all
      else
        if current_user.role == "1" or current_user.role == "2"
          @users = User.where(:area_id => current_user.area.id)
        else
          redirect_to root_path, :alert => "Access denied."
        end
      end
    else
      redirect_to new_user_session_path, :alert => "Access denied."
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


  # GET /users/1
  # GET /users/1.json
  def show
    query = Procedure.by_user(@user) 
    @procedures = query.group(:surgery).count
    @procedure =  query.to_a
  end

  # GET /users/new
  def new
    if user_signed_in?
      if current_user.role == "Admin"
        @user = User.new
      else
        if current_user.role == "1"
          @user = User.new(:area_id => current_user.area.id)
        else
          redirect_to root_path, :alert => "Access denied."
        end
      end
    else
      redirect_to new_user_session_path, :alert => "Access denied."
    end
  end

  # GET /users/1/edit
  def edit
    @user.season = Season.last
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.role == "3"
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

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.name = @user.name.titleize
        @user.lastname = @user.lastname.titleize
        @user = User.new(user_params)
        if @user.role == "3"
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
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


    # should be coll after the user is setin @user
    def set_procedure_hash
      if params[:type] == 'month'
        @procedures_hash = @user.month_procedure_count
      elsif params[:type] == 'day'
        @procedures_hash = @user.day_procedures_count
      else
        @procedures_hash = @user.month_procedure_count
      end
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if user_signed_in?
        if current_user.role == "Admin"
           @user = User.find(params[:id])
        else
          @user = User.find(params[:id])
          if current_user.id.to_i != @user.id.to_i
            if current_user.role == "1" or current_user.role == "2"
              if @user.role == "Admin" 
                redirect_to root_path, :alert => "Acceso denegado."
              else
                if current_user.area.id.to_i != @user.area.id.to_i
                  redirect_to root_path, :alert => "Acceso denegado."
                end 
              end
            else
              redirect_to root_path, :alert => "Acceso denegado."
            end
          end
        end
      else
        redirect_to new_user_session_path, :alert => "Acceso denegado."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, :birthday, :gender, :role, :area_id, :pd, :season_id)
    end
end
