# frozen_string_literal: true

class LogEntriesController < ApplicationController
  before_action :find_modifiable_entry, only: %i[destroy update]

  def create
    @entry = LogEntry.new entry_params.merge(user: @current_user)
    if @entry.save
      flash[:success] = 'Log entry was successfully created.'
    else
      flash[:danger] = @entry.errors.full_messages
    end
    redirect_to log_entries_path
  end

  def destroy
    if @entry.destroy
      flash[:success] = 'Log entry was successfully deleted.'
    else
      # skip coverage until LogEntry deletion can possibly be restrained
      # :nocov:
      flash[:danger] = @log.errors.full_messages
      # :nocov:
    end
    redirect_to log_entries_path
  end

  def index
    @entry = LogEntry.new
    @entries = LogEntry.includes(:user).order(pinned: :desc, created_at: :desc)
                       .page(params[:page] || 1)
  end

  def update
    if @entry.update entry_params
      flash[:success] = 'Log entry was successfully changed.'
    else
      flash[:danger] = @entry.errors.full_messages
    end
    redirect_to log_entries_path
  end

  private

  def find_modifiable_entry
    @entry = LogEntry.find params.require(:id)
    deny_access and return unless @current_user.can_modify? @entry
  end

  def entry_params
    params.require(:log_entry).permit(:text, @current_user.admin? ? :pinned : nil)
  end
end
