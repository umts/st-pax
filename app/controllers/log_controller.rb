# frozen_string_literal: true

class LogController < ApplicationController
  skip_before_action :access_control, except: :update

  before_action :find_entry, only: %i[destroy update]
  before_action :set_entries

  def create
    @entry = LogEntry.new entry_params.merge(user: @current_user)
    if @entry.save
      flash[:success] = 'Log entry was successfully created.'
      redirect_to log_index_path
    else
      flash[:danger] = @entry.errors.full_messages
      render :index
    end
  end

  # rubocop:disable Style/AndOr
  def destroy
    deny_access and return unless @current_user.can_delete? @entry
    if @entry.destroy
      flash[:success] = 'Log entry was successfully deleted.'
      redirect_to log_index_path
    else
      flash[:danger] = @log.errors.full_messages
      redirect_to log_index_path
    end
  end
  # rubocop:enable Style/AndOr

  def index
    @entry = LogEntry.new
  end

  def update
    if @entry.update entry_params
      flash[:success] = 'Log entry was successfully changed.'
      redirect_to log_index_path
    else
      flash[:danger] = @entry.errors.full_messages
      render log_index_path
    end
  end

  private

  def find_entry
    @entry = LogEntry.find_by id: params.require(:id)
  end

  def entry_params
    params.require(:log_entry).permit(:text)
  end

  def set_entries
    @entries = LogEntry.includes(:user).order('created_at desc')
                       .page(params[:page] || 1)
  end
end
