class DashboardController < AuthenticatedController
  def index
    @pull_requests = OpenedPullRequestsQuery.new.results
  end
end
