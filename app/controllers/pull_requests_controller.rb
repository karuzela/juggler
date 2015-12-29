class PullRequestsController < AuthenticatedController
  before_action :load_pull_request

  def show
  end

  def take
    authorize!(:take, @pull_request)
    success, msg = TakePullRequestService.new(@pull_request, current_user).call
    if success
      redirect_to :back, notice: msg
    else
      redirect_to :back, alert: msg
    end
  end

  def resolve
    authorize!(:resolve, @pull_request)

    if params[:commit] == 'Accept'
      AcceptPullRequestService.new(@pull_request).call
      redirect_to root_path, notice: 'Pull request accepted'
    elsif params[:commit] == 'Reject'
      RejectPullRequestService.new(@pull_request).call
      redirect_to root_path, notice: 'Pull request rejected'
    else
      redirect_to root_path, alert: 'Invalid action'
    end
  end

  private

  def load_pull_request
    @pull_request = PullRequest.find(params[:id])
  end
end