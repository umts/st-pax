# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[destroy edit update]

  def index
    @users = User.order(:name)
    if params[:show_inactive]
      @show_inactive = true
    else @users = @users.active
    end
  end

  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_url, notice: 'User was successfully created.'
    else render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_url, notice: 'User was successfully destroyed.'
    else redirect_to users_url,
                     alert: 'Cannot delete users who have made log entries.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if @current_user.admin?
      params.require(:user).permit(:name, :spire, :active, :admin)
    else
      params.require(:user).permit(:name, :spire)
    end
  end
end
