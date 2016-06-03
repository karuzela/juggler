class TakePullRequestService
  def initialize(pr, user)
    @pull_request = pr
    @user = user
  end

  def call
    if @user.nil?
      return false, 'Juggler: user not found'
    end
    if @pull_request.update(reviewer: @user)
      SendStatusToGithubPullRequest.new(@pull_request, PullRequestState::PENDING).call
      ReminderWorker.perform_at(@pull_request.repository.remind_time.hours.from_now, @pull_request.id)
      success = true
      message = "You were assigned to pull request: #{@pull_request.title}"
    else
      success = false
      message =  'You can\'t be assigned to this pull request'
    end
    return success, message
  end
end
