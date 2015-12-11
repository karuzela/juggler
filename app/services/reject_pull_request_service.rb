class RejectPullRequestService
  def initialize(pull_request, params)
    @pull_request = pull_request
    @params = params
  end

  def call
    return if @pull_request.state == PullRequestState::REJECTED

    @pull_request.state = PullRequestState::REJECTED
    @pull_request.save
  end
end
