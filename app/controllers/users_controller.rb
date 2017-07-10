class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |_format|
      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    respond_to do |_format|
      if @user.update(user_params)
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    if @user.admin?
      params.require(:user).permit(:name, :email, :phone, :spire, :active, :admin)
    else
      params.require(:user).permit(:name, :email, :phone, :spire)
    end
  end
end
