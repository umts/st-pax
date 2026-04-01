# frozen_string_literal: true

class LogEntriesController < ApplicationController
  before_action :find_modifiable_entry, only: %i[destroy update]

  def index; end

  def create
    redirect_to log_entries_path
  end

  def update
    redirect_to log_entries_path
  end

  def destroy
    redirect_to log_entries_path
  end

  def export
    send_data LogEntry.includes(:user).to_export_csv,
              type: Mime[:csv],
              disposition: 'attachment; filename=log_entries.csv'
  end

  private

  def find_modifiable_entry
    @entry = LogEntry.find params.require(:id)
    deny_access and return unless Current.user.can_modify? @entry
  end

  def entry_params
    params.expect log_entry: [:text, Current.user.admin? ? :pinned : nil]
  end
end
