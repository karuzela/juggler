class AcceptPullRequestService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return if @pull_request.accepted? || !@pull_request.can_be_reviewed?

    @pull_request.update_attributes(state: PullRequestState::ACCEPTED)
    SendStatusToGithubPullRequest.new(@pull_request, PullRequestState::ACCEPTED).call
  end
end
