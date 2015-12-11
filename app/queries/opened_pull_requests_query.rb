class OpenedPullRequestsQuery
  def results
    results = PullRequest.where(state: [PullRequestState::PENDING, PullRequestState::REJECTED])
    results = results.order("opened_at ASC")
    results
  end
end
