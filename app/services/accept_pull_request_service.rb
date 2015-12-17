class AcceptPullRequestService
  def initialize(pull_request, params, user)
    @pull_request = pull_request
    @params = params
    @client = Octokit::Client.new(access_token: user.github_access_token, auto_paginate: true)
  end

  def call
    return if @pull_request.accepted? or not @pull_request.can_be_reviewed?

    @pull_request.state = PullRequestState::ACCEPTED
    @pull_request.save
  end
end
