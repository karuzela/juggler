class RejectPullRequestService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return if @pull_request.rejected? || !@pull_request.can_be_reviewed?

    @pull_request.update_attributes(state: PullRequestState::REJECTED)
    SendStatusToGithubPullRequest.new(@pull_request, PullRequestState::REJECTED).call
  end
end