# frozen_string_literal: true

class FeedbackController < ApplicationController
  skip_before_action :restrict_to_employee

  def show
    @feedback = Feedback.new
    begin
      @feedback.load(params[:id])
    rescue Octokit::Error => e
      flash[:warning] = "Could not display issue: #{e}"
      redirect_to feedback_index_path
    end
  end

  def new
    render 'authorize' and return unless IssueToken.usable?

    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    if submitted_feedback?
      flash[:info] = t('.success')
      redirect_to feedback_path(@feedback.issue.number)
    else
      flash.now[:danger] = @feedback.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  private

  def feedback_params
    params.expect(feedback: %i[title description category])
          .merge(user: Current.user)
  end

  def submitted_feedback?
    return false unless @feedback.valid?

    begin
      @feedback.submit!
    rescue Octokit::Error => e
      @feedback.errors.add(:base, "An external error occurred: #{e}")
      return false
    end
    true
  end
end
