class PullRequestsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_pull_request, only: [:show, :take]

  def index

  end

  def show
  end

  def take
    if @pull_request.update(reviewer: current_user)
      ReminderWorker.perform_at(ENV["REMAIND_AFTER_HOURS"].to_i.hours.from_now, @pull_request.id)
      redirect_to :back
    else
      redirect_to :back, alert: 'You can\'t be assigne to this pull request'
    end
  end

  private
  def set_pull_request
    @pull_request = PullRequest.find(params[:id])
  end
end
