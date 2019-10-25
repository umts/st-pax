class FeedbackController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.valid?
      begin
        @feedback.submit!
      rescue Octokit::Error => e
        @feedback.errors.add(:base, e.message)
        render :new and return
      end
      redirect_to feedback_path(@feedback.issue.number),
        notice: 'Feedback was successfully submitted.'
    else
      render :new
    end
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
