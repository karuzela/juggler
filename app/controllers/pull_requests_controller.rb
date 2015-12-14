class PullRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_pull_request, only: [:show, :take, :resolve]

  def show
  end

  def take
    authorize!(:take, @pull_request)

    if @pull_request.update(reviewer: current_user)
      ReminderWorker.perform_at(ENV["REMAIND_AFTER_HOURS"].to_i.hours.from_now, @pull_request.id)
      redirect_to :back
    else
      redirect_to :back, alert: 'You can\'t be assigne to this pull request'
    end
  end

  def resolve
    authorize!(:resolve, @pull_request)

    if params[:commit] == 'Accept'
      AcceptPullRequestService.new(@pull_request, resolve_params, current_user).call
      redirect_to root_path, alert: 'Pull request accepted'
    elsif params[:commit] == 'Reject'
      RejectPullRequestService.new(@pull_request, resolve_params, current_user).call
      redirect_to root_path, alert: 'Pull request rejected'
    else
      redirect_to root_path, alert: 'Invalid action'
    end
  end

  private

  def load_pull_request
    @pull_request = PullRequest.find(params[:id])
  end

  def resolve_params
    params[:pull_request].permit(:comment)
  end
end
