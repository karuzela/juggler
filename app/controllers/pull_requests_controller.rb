class PullRequestsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_pull_request, only: [:show, :take, :resolve]

  def index
    @pull_requests = PullRequest.all
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

  def resolve
    if params[:commit] == 'Accept'
      AcceptPullRequestService.new(@pull_request).call
      redirect_to root_path, alert: 'Pull request accepted'
    elsif params[:commit] == 'Reject'
      RejectPullRequestService.new(@pull_request).call
      redirect_to root_path, alert: 'Pull request rejected'
    else
      redirect_to root_path, alert: 'Invalid action'
    end
  end

  private
  def set_pull_request
    @pull_request = PullRequest.find(params[:id])
  end
end
