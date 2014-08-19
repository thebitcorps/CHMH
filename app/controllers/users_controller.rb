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

  # GET /users/1
  # GET /users/1.json
  def show
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
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.role == "3"
      @user.season = Season.last
    end
    @user.password = "cambiarcontrasena"
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
        format.html { redirect_to root_path, notice: 'Cosas.' }
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
      format.html { redirect_to root_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
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
                redirect_to root_path, :alert => "Access denied."
              else
                if current_user.area.id.to_i != @user.area.id.to_i
                  redirect_to root_path, :alert => "Access denied."
                end 
              end
            else
              redirect_to root_path, :alert => "Access denied."
            end
          end
        end
      else
        redirect_to new_user_session_path, :alert => "Access denied."
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, :birthday, :gender, :role, :area_id, :pd)
    end
end
