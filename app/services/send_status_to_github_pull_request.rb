class SendStatusToGithubPullRequest
  def initialize(pr, status, opts={})
    access_token ||= ENV['GITHUB_ACCESS_TOKEN']
    @client = Octokit::Client.new(access_token: access_token, auto_paginate: true)
    @pull_request = pr
    @reviewer = @pull_request.reviewer ? @pull_request.reviewer.email : 'unknown'
    @state, @description = get_state_and_description(status)
  end

  def call
    commits_sha = @client.pull_request_commits(@pull_request.repository.full_name, @pull_request.issue_number).collect { |x| x.sha }
    commits_sha.each do |sha|
      @client.create_status(@pull_request.repository.full_name, sha, @state, description: @description, context: 'juggler')
    end
  end

  private

  def get_state_and_description(status)
    case status
    when 'unassigned'
      ['pending', "This pull request is not assigned to any developer."]
    when 'pending'
      ['pending', "This pull request is being reviewed by #{@reviewer}"]
    when 'accepted'
      ['success', "Pull request was accepted by #{@reviewer}"]
    when 'rejected'
      ['failure', "Pull request was rejected by #{@reviewer}"]
    end
  end
end