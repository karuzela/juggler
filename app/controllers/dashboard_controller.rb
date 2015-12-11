class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @pull_requests = OpenedPullRequestsQuery.new.results
  end
end
