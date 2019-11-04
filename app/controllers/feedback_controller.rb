# frozen_string_literal: true

class FeedbackController < ApplicationController
  skip_before_action :access_control

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    render(:new) && return unless @feedback.valid?

    begin
      @feedback.submit!
    rescue Octokit::Error => e
      @feedback.errors.add(:base, e.message)
      render(:new) && return
    end
    redirect_to feedback_path(@feedback.issue.number),
                notice: 'Feedback was successfully submitted.'
  end

  def show
    @feedback = Feedback.new
    @feedback.load(params[:id])
  end

  private

  def feedback_params
    params.require(:feedback).permit(:title, :description, :category)
  end
end
