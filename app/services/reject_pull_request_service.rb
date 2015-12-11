class RejectPullRequestService
  def initialize(pull_request)
    @pull_request = pull_request
  end

  def call
    return if @pull_request.state == PullRequestState::REJECTED

    @pull_request.state = PullRequestState::REJECTED
    @pull_request.save
  end
end
