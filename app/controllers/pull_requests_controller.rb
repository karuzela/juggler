class PullRequestsController < ApplicationController

  def index

  end

  def show
    @pull_request = PullRequest.find(params[:id])
  end
end
