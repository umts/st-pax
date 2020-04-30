# frozen_string_literal: true

class FeedbackController < ApplicationController
  skip_before_action :restrict_to_employee

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = @current_user
    unless @feedback.valid?
      flash.now[:danger] = @feedback.errors.full_messages
      render(:new) && return
    end

    begin
      @feedback.submit!
    rescue Octokit::Error => e
      flash.now[:danger] = "An external error occurred: #{e}"
      render(:new) && return
    end

    flash[:info] = 'Feedback was successfully submitted.'
    redirect_to feedback_path(@feedback.issue.number)
  end

  def show
    @feedback = Feedback.new
    begin
      @feedback.load(params[:id])
    rescue Octokit::Error => e
      flash[:warning] = "Could not display issue: #{e}"
      redirect_to feedback_index_path
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :description, :category)
  end
end
