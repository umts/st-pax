class LogController < ApplicationController
  before_action :find_entry, except: :index
  before_action :set_entries

  def create
    @entry = LogEntry.new entry_params.merge(user: @current_user)
    if @entry.save
      redirect_to log_index_path, notice: 'Log entry was successfully created.'
    else render log_index_path
    end
  end

  def destroy
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
    @entry = LogEntry.find_by params.require(:id)
  end

  def entry_params
    params.require(:log).permit(:text)
  end

  def set_entries
    @entries = LogEntry.includes(:user).order 'created_at desc'
  end
end
