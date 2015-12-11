class PullRequestsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_pull_request, only: [:show, :take]

  def index
    @pull_requests = PullRequest.all
  end

  def show
  end

  def take
    if @pull_request.update(reviewer: current_user)
      redirect_to :back
    else
      redirect_to :back, alert: 'You can\'t be assigne to this pull request'
    end
  end

  private
  def set_pull_request
    @pull_request = PullRequest.find(params[:id])
  end
end
