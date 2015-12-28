class PullRequestsController < AuthenticatedController
  skip_before_filter :verify_authenticity_token, only: [:neko_claim]
  skip_before_filter :authenticate_user!, only: [:neko_claim]
  before_action :load_pull_request, only: [:show, :take, :resolve]

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

  def neko_claim
    @pull_request = PullRequest.find_by_token(params[:token])
    user = params[:slack_username].present? ? User.find_by_slack_username(params[:slack_username]) : nil
    if @pull_request.nil?
      render json: {msg: 'Pull request not found.'}
    elsif !@pull_request.can_be_taken?
      render json: {msg: 'This pull request has already been claimed'}
    else
      _, msg = TakePullRequestService.new(@pull_request, user).call
      render json: {msg: msg}
    end
  end

  private

  def load_pull_request
    @pull_request = PullRequest.find(params[:id])
  end
end