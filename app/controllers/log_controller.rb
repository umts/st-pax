# frozen_string_literal: true

class LogController < ApplicationController
  before_action :find_modifiable_entry, only: %i[destroy update]

  def create
    @entry = LogEntry.new entry_params.merge(user: @current_user)
    if @entry.save
      flash[:success] = 'Log entry was successfully created.'
    else
      flash[:danger] = @entry.errors.full_messages
    end
    redirect_to log_index_path
  end

  def destroy
    if @entry.destroy
      flash[:success] = 'Log entry was successfully deleted.'
    else
      flash[:danger] = @log.errors.full_messages
    end
    redirect_to log_index_path
  end

  def index
    @entry = LogEntry.new
    @entries = LogEntry.includes(:user).order('created_at desc')
                       .page(params[:page] || 1)
  end

  def update
    if @entry.update entry_params
      flash[:success] = 'Log entry was successfully changed.'
    else
      flash[:danger] = @entry.errors.full_messages
    end
    redirect_to log_index_path
  end

  private

  def find_modifiable_entry
    @entry = LogEntry.find_by id: params.require(:id)
    deny_access and return unless @current_user.can_modify? @entry
  end

  def entry_params
    params.require(:log_entry).permit(:text)
  end
end
