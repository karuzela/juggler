class AcceptPullRequestService
  def initialize(pull_request, params, user)
    @pull_request = pull_request
    @params = params
    @client = Octokit::Client.new(access_token: user.github_access_token, auto_paginate: true)
  end

  def call
    return if @pull_request.state == PullRequestState::ACCEPTED

    @pull_request.state = PullRequestState::ACCEPTED
    @pull_request.save
    send_comment_to_github if @pull_request.issue_number.present?
  end

  def send_comment_to_github
    @client.add_comment(@pull_request.repository.full_name, @pull_request.issue_number, 'Accepted: ' + @pull_request.body)
  end
end
