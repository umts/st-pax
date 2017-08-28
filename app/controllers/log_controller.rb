# frozen_string_literal: true

class LogController < ApplicationController
  skip_before_action :access_control, except: :update

  before_action :find_entry, only: %i[destroy update]
  before_action :set_entries

  def create
    @entry = LogEntry.new entry_params.merge(user: @current_user)
    if @entry.save
      redirect_to log_index_path, notice: 'Log entry was successfully created.'
    else render log_index_path
    end
  end

  def destroy
    deny_access && return unless @current_user.can_delete? @entry
    @entry.destroy
    redirect_to log_index_path, notice: 'Log entry was successfully deleted.'
  end

  def index
    @entry = LogEntry.new
  end

  def update
    if @entry.update entry_params
      redirect_to log_index_path, notice: 'Log entry was successfully changed.'
    else render log_index_path
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
    @entries = LogEntry.includes(:user).order('created_at desc').limit 100
  end
end
