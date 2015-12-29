class Api::PullRequestsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def claim
    @pull_request = PullRequest.find_by_token(params[:token])
    user = params[:slack_username].present? ? User.find_by_slack_username(params[:slack_username]) : nil
    if @pull_request.nil?
      render json: {msg: 'Pull request not found.'}
    elsif !@pull_request.can_be_taken?
      render json: {msg: 'This pull request has already been claimed'}
    else
      _, msg = TakePullRequestService.new(@pull_request, user).call
      render json: {msg: msg}
    end
  end

end